Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B782F212B
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 21:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbhAKUwR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 11 Jan 2021 15:52:17 -0500
Received: from mail.fireflyinternet.com ([77.68.26.236]:53934 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727363AbhAKUwQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 15:52:16 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from localhost (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP (TLS) id 23564345-1500050 
        for multiple; Mon, 11 Jan 2021 20:51:26 +0000
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20210111173512.GA3689@intel.com>
References: <20210110150404.19535-1-chris@chris-wilson.co.uk> <20210111173512.GA3689@intel.com>
Subject: Re: [Intel-gfx] [PATCH 01/11] drm/i915/gt: Limit VFE threads based on GT
From:   Chris Wilson <chris@chris-wilson.co.uk>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org,
        Randy Wright <rwright@hpe.com>
To:     Rodrigo Vivi <rodrigo.vivi@intel.com>
Date:   Mon, 11 Jan 2021 20:51:23 +0000
Message-ID: <161039828373.28181.4936101209209634775@build.alporthouse.com>
User-Agent: alot/0.9
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Rodrigo Vivi (2021-01-11 17:35:12)
> On Sun, Jan 10, 2021 at 03:03:54PM +0000, Chris Wilson wrote:
> > MEDIA_STATE_VFE only accepts the 'maximum number of threads' in the
> > range [0, n-1] where n is #EU * (#threads/EU) with the number of threads
> > based on plaform and the number of EU based on the number of slices and
> > subslices. This is a fixed number per platform/gt, so appropriately
> > limit the number of threads we spawn to match the device.
> > 
> > v2: Oversaturate the system with tasks to force execution on every HW
> > thread; if the thread idles it is returned to the pool and may be reused
> > again before an unused thread.
> > 
> > v3: Fix more state commands, which was causing Baytrail to barf.
> 
> CI is still not happy with byt right? or is that false positive?

After v3, ivb still failed.
 
> > v4: STATE_CACHE_INVALIDATE requires a stall on Ivybridge

Right now with the multiple pipecontrls around the PIPELINE_SELECT *and*
STATE_BASE, CI has been happy for multiple runs. I was able to reproduce
the same selftests failures and confirm that we do not see any of those
failures in a thousand iterations. High level of confidence, but since
we are dealing with empirical results with cross-referencing to mesa who
also have seen similar undocumented failures, there's still an element
of doubt as to whether it is truly watertight.

The CI results for this series passed on the all important ivb,byt,hsw.

> > Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2024
> > Fixes: 47f8253d2b89 ("drm/i915/gen7: Clear all EU/L3 residual contexts")
> > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> > Cc: Prathap Kumar Valsan <prathap.kumar.valsan@intel.com>
> > Cc: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>
> > Cc: Jon Bloomfield <jon.bloomfield@intel.com>
> > Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
> > Cc: Randy Wright <rwright@hpe.com>
> > Cc: stable@vger.kernel.org # v5.7+
> > ---
> >  drivers/gpu/drm/i915/gt/gen7_renderclear.c | 157 ++++++++++++---------
> >  1 file changed, 94 insertions(+), 63 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/i915/gt/gen7_renderclear.c b/drivers/gpu/drm/i915/gt/gen7_renderclear.c
> > index d93d85cd3027..f32a8e8040b2 100644
> > --- a/drivers/gpu/drm/i915/gt/gen7_renderclear.c
> > +++ b/drivers/gpu/drm/i915/gt/gen7_renderclear.c
> > @@ -7,8 +7,6 @@
> >  #include "i915_drv.h"
> >  #include "intel_gpu_commands.h"
> >  
> > -#define MAX_URB_ENTRIES 64
> > -#define STATE_SIZE (4 * 1024)
> >  #define GT3_INLINE_DATA_DELAYS 0x1E00
> >  #define batch_advance(Y, CS) GEM_BUG_ON((Y)->end != (CS))
> >  
> > @@ -34,38 +32,59 @@ struct batch_chunk {
> >  };
> >  
> >  struct batch_vals {
> > -     u32 max_primitives;
> > -     u32 max_urb_entries;
> > -     u32 cmd_size;
> > -     u32 state_size;
> > +     u32 max_threads;
> >       u32 state_start;
> > -     u32 batch_size;
> > +     u32 surface_start;
> >       u32 surface_height;
> >       u32 surface_width;
> > -     u32 scratch_size;
> > -     u32 max_size;
> > +     u32 size;
> >  };
> >  
> > +static inline int num_primitives(const struct batch_vals *bv)
> > +{
> > +     /*
> > +      * We need to saturate the GPU with work in order to dispatch
> > +      * a shader on every HW thread, and clear the thread-local registers.
> > +      * In short, we have to dispatch work faster than the shaders can
> > +      * run in order to fill occupy each HW thread.
> > +      */
> > +     return bv->max_threads;
> > +}
> > +
> >  static void
> >  batch_get_defaults(struct drm_i915_private *i915, struct batch_vals *bv)
> >  {
> >       if (IS_HASWELL(i915)) {
> > -             bv->max_primitives = 280;
> > -             bv->max_urb_entries = MAX_URB_ENTRIES;
> > +             switch (INTEL_INFO(i915)->gt) {
> > +             default:
> > +             case 1:
> > +                     bv->max_threads = 70;
> > +                     break;
> > +             case 2:
> > +                     bv->max_threads = 140;
> > +                     break;
> > +             case 3:
> > +                     bv->max_threads = 280;
> > +                     break;
> > +             }
> >               bv->surface_height = 16 * 16;
> >               bv->surface_width = 32 * 2 * 16;
> >       } else {
> > -             bv->max_primitives = 128;
> > -             bv->max_urb_entries = MAX_URB_ENTRIES / 2;
> > +             switch (INTEL_INFO(i915)->gt) {
> > +             default:
> > +             case 1: /* including vlv */
> > +                     bv->max_threads = 36;
> > +                     break;
> > +             case 2:
> > +                     bv->max_threads = 128;
> > +                     break;
> > +             }
> >               bv->surface_height = 16 * 8;
> >               bv->surface_width = 32 * 16;
> 
> all the values above matches the spec.
> 
> >       }
> > -     bv->cmd_size = bv->max_primitives * 4096;
> > -     bv->state_size = STATE_SIZE;
> > -     bv->state_start = bv->cmd_size;
> > -     bv->batch_size = bv->cmd_size + bv->state_size;
> > -     bv->scratch_size = bv->surface_height * bv->surface_width;
> > -     bv->max_size = bv->batch_size + bv->scratch_size;
> > +     bv->state_start = round_up(SZ_1K + num_primitives(bv) * 64, SZ_4K);
> > +     bv->surface_start = bv->state_start + SZ_4K;
> > +     bv->size = bv->surface_start + bv->surface_height * bv->surface_width;
> 
> I liked this batch values simplification...
> 
> >  }
> >  
> >  static void batch_init(struct batch_chunk *bc,
> > @@ -155,7 +174,8 @@ static u32
> >  gen7_fill_binding_table(struct batch_chunk *state,
> >                       const struct batch_vals *bv)
> >  {
> > -     u32 surface_start = gen7_fill_surface_state(state, bv->batch_size, bv);
> > +     u32 surface_start =
> > +             gen7_fill_surface_state(state, bv->surface_start, bv);
> >       u32 *cs = batch_alloc_items(state, 32, 8);
> >       u32 offset = batch_offset(state, cs);
> >  
> > @@ -214,9 +234,9 @@ static void
> >  gen7_emit_state_base_address(struct batch_chunk *batch,
> >                            u32 surface_state_base)
> >  {
> > -     u32 *cs = batch_alloc_items(batch, 0, 12);
> > +     u32 *cs = batch_alloc_items(batch, 0, 10);
> >  
> > -     *cs++ = STATE_BASE_ADDRESS | (12 - 2);
> > +     *cs++ = STATE_BASE_ADDRESS | (10 - 2);
> >       /* general */
> >       *cs++ = batch_addr(batch) | BASE_ADDRESS_MODIFY;
> >       /* surface */
> > @@ -233,8 +253,6 @@ gen7_emit_state_base_address(struct batch_chunk *batch,
> >       *cs++ = BASE_ADDRESS_MODIFY;
> >       *cs++ = 0;
> >       *cs++ = BASE_ADDRESS_MODIFY;
> > -     *cs++ = 0;
> > -     *cs++ = 0;
> 
> why don't we need this anymore?

It was incorrect, gen7 is just (10-2). The last two were extraneous
padding.

> >       batch_advance(batch, cs);
> >  }
> >  
> > @@ -244,8 +262,7 @@ gen7_emit_vfe_state(struct batch_chunk *batch,
> >                   u32 urb_size, u32 curbe_size,
> >                   u32 mode)
> >  {
> > -     u32 urb_entries = bv->max_urb_entries;
> > -     u32 threads = bv->max_primitives - 1;
> > +     u32 threads = bv->max_threads - 1;
> >       u32 *cs = batch_alloc_items(batch, 32, 8);
> >  
> >       *cs++ = MEDIA_VFE_STATE | (8 - 2);
> > @@ -254,7 +271,7 @@ gen7_emit_vfe_state(struct batch_chunk *batch,
> >       *cs++ = 0;
> >  
> >       /* number of threads & urb entries for GPGPU vs Media Mode */
> > -     *cs++ = threads << 16 | urb_entries << 8 | mode << 2;
> > +     *cs++ = threads << 16 | 1 << 8 | mode << 2;
> >  
> >       *cs++ = 0;
> >  
> > @@ -293,17 +310,12 @@ gen7_emit_media_object(struct batch_chunk *batch,
> >  {
> >       unsigned int x_offset = (media_object_index % 16) * 64;
> >       unsigned int y_offset = (media_object_index / 16) * 16;
> > -     unsigned int inline_data_size;
> > -     unsigned int media_batch_size;
> > -     unsigned int i;
> > +     unsigned int pkt = 6 + 3;
> >       u32 *cs;
> >  
> > -     inline_data_size = 112 * 8;
> > -     media_batch_size = inline_data_size + 6;
> > +     cs = batch_alloc_items(batch, 8, pkt);
> >  
> > -     cs = batch_alloc_items(batch, 8, media_batch_size);
> > -
> > -     *cs++ = MEDIA_OBJECT | (media_batch_size - 2);
> > +     *cs++ = MEDIA_OBJECT | (pkt - 2);
> >  
> >       /* interface descriptor offset */
> >       *cs++ = 0;
> > @@ -317,25 +329,44 @@ gen7_emit_media_object(struct batch_chunk *batch,
> >       *cs++ = 0;
> >  
> >       /* inline */
> > -     *cs++ = (y_offset << 16) | (x_offset);
> > +     *cs++ = y_offset << 16 | x_offset;
> >       *cs++ = 0;
> >       *cs++ = GT3_INLINE_DATA_DELAYS;
> > -     for (i = 3; i < inline_data_size; i++)
> > -             *cs++ = 0;
> 
> why?

We don't use the extra urb data, and worse the extra inline data slows
down the CP to be slower than the thread dispatch. That was causing the 
issue that the same HW thread was servicing multiple MEDIA_OBJECTS, and
we did not then clear all the thread-local registers across the EU (as
some threads never executed our shader). And that was the cause of the
validation failures in v1.

[The first clue was that if we submitted more a few more objects than
threads with v1, it takes twice as long, and passes the validation test.
Now, touch wood, it appears that we are able to saturate the HW threads
with an equal number of objects, so every HW thread does exactly one
iteration of the shader.]

> >       batch_advance(batch, cs);
> >  }
> >  
> >  static void gen7_emit_pipeline_flush(struct batch_chunk *batch)
> >  {
> > -     u32 *cs = batch_alloc_items(batch, 0, 5);
> > +     u32 *cs = batch_alloc_items(batch, 0, 4);
> >  
> > -     *cs++ = GFX_OP_PIPE_CONTROL(5);
> > -     *cs++ = PIPE_CONTROL_STATE_CACHE_INVALIDATE |
> > -             PIPE_CONTROL_GLOBAL_GTT_IVB;
> > +     *cs++ = GFX_OP_PIPE_CONTROL(4);
> > +     *cs++ = PIPE_CONTROL_RENDER_TARGET_CACHE_FLUSH |
> > +             PIPE_CONTROL_DEPTH_CACHE_FLUSH |
> > +             PIPE_CONTROL_DC_FLUSH_ENABLE |
> > +             PIPE_CONTROL_CS_STALL;
> >       *cs++ = 0;
> >       *cs++ = 0;
> > +
> > +     batch_advance(batch, cs);
> > +}
> > +
> > +static void gen7_emit_pipeline_invalidate(struct batch_chunk *batch)
> > +{
> > +     u32 *cs = batch_alloc_items(batch, 0, 8);
> > +
> > +     /* ivb: Stall before STATE_CACHE_INVALIDATE */
> > +     *cs++ = GFX_OP_PIPE_CONTROL(4);
> > +     *cs++ = PIPE_CONTROL_STALL_AT_SCOREBOARD |
> > +             PIPE_CONTROL_CS_STALL;
> >       *cs++ = 0;
> > +     *cs++ = 0;
> > +
> > +     *cs++ = GFX_OP_PIPE_CONTROL(4);
> > +     *cs++ = PIPE_CONTROL_STATE_CACHE_INVALIDATE;
> > +     *cs++ = 0;
> > +     *cs++ = 0;
> > +
> >       batch_advance(batch, cs);
> >  }
> >  
> > @@ -344,34 +375,34 @@ static void emit_batch(struct i915_vma * const vma,
> >                      const struct batch_vals *bv)
> >  {
> >       struct drm_i915_private *i915 = vma->vm->i915;
> > -     unsigned int desc_count = 64;
> > -     const u32 urb_size = 112;
> > +     const unsigned int desc_count = 1;
> > +     const unsigned int urb_size = 1;
> >       struct batch_chunk cmds, state;
> > -     u32 interface_descriptor;
> > +     u32 descriptors;
> >       unsigned int i;
> >  
> > -     batch_init(&cmds, vma, start, 0, bv->cmd_size);
> > -     batch_init(&state, vma, start, bv->state_start, bv->state_size);
> > +     batch_init(&cmds, vma, start, 0, bv->state_start);
> > +     batch_init(&state, vma, start, bv->state_start, SZ_4K);
> >  
> > -     interface_descriptor =
> > -             gen7_fill_interface_descriptor(&state, bv,
> > -                                            IS_HASWELL(i915) ?
> > -                                            &cb_kernel_hsw :
> > -                                            &cb_kernel_ivb,
> > -                                            desc_count);
> > -     gen7_emit_pipeline_flush(&cmds);
> > +     descriptors = gen7_fill_interface_descriptor(&state, bv,
> > +                                                  IS_HASWELL(i915) ?
> > +                                                  &cb_kernel_hsw :
> > +                                                  &cb_kernel_ivb,
> > +                                                  desc_count);
> > +
> > +     gen7_emit_pipeline_invalidate(&cmds);
> >       batch_add(&cmds, PIPELINE_SELECT | PIPELINE_SELECT_MEDIA);
> >       batch_add(&cmds, MI_NOOP);
> > -     gen7_emit_state_base_address(&cmds, interface_descriptor);
> > +     gen7_emit_pipeline_invalidate(&cmds);
> > +
> >       gen7_emit_pipeline_flush(&cmds);
> > +     gen7_emit_state_base_address(&cmds, descriptors);
> > +     gen7_emit_pipeline_invalidate(&cmds);
> 
> why do we need double invalidate?

Empirical results. We need the flush before STATE_BASE otherwise there
were lost writes; mesa has had a similar experience with needing a
magical flush before. The invalidate afterwards is similarly required by
the HW.

The invalidate before the PIPELINE_SELECT is mandatory in bspec for MEDIA,
and vouched for by our CI results. The one after the PIPELINE_SELECT does
not appear in the docs, yet preferred by CI.

It's this combination of flush/invalidate that finally worked on all
three gen7 platforms, but there's almost definitely a more optimal set of
pipecontrols.
-Chris
