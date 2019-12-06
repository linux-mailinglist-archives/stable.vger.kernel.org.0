Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 953C911580B
	for <lists+stable@lfdr.de>; Fri,  6 Dec 2019 20:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfLFT5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Dec 2019 14:57:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60139 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726325AbfLFT5J (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Dec 2019 14:57:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575662227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mnbiz0aMko2Xu1mk9CJ3thPybxK/sVkyzXNX584wmt4=;
        b=XxXDYza/vlKGr9AE6wrGWt2pH0ViEWLAkD8UvaS0GmLFlVZwg47g03xeAYQpvG61bcoL6A
        pp9rAVGBfeT7MXBhTvI0wJv7NG2vT4Si1+91HK4dA9xkv8SJ6kx8q+VrGNeAJ1FNXr9yMK
        60cZoYYheexr+589san+lksX/JIMbZI=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-HXGKeKrEOU-Ov_gEmHJJJw-1; Fri, 06 Dec 2019 14:57:04 -0500
Received: by mail-qv1-f70.google.com with SMTP id d7so530814qvq.12
        for <stable@vger.kernel.org>; Fri, 06 Dec 2019 11:57:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=mnbiz0aMko2Xu1mk9CJ3thPybxK/sVkyzXNX584wmt4=;
        b=WfnHTaXEIhWKVcWXgZjxmYo2BUjYxhAFamH+YgCzF8kKVLqR1Hq0HBSfAhrNC97a8l
         WOj6yFgBRJOxjGhwdmCi/U01vFHSnnSAxKiLIGJQ3bsM371gc3JtVjYV02J8hua8434b
         zYLdaminLrmRQNixAkB+Af7mSQbw2XX8eSXyu1+9btolrPPJ0AVJNF0xD2MOh5LbW0NQ
         W2sW0KN4Bc6D3n45Nf/64NzXa3NP4RFLDAIg0nkz187zgL3QnwmTxjI9DGCj2+5p8TkZ
         nBq7iDCJUyKfpe51Pgn85mJzotd3xVbZ48czcX/CaL+Z0XhE5uZierfbnqSoB0KRstzQ
         L4RQ==
X-Gm-Message-State: APjAAAVsH8E5N9Y/73+zALreM+7lS5rTh+YiuFOsWiJKoJjlf7JyJfWU
        +fYK3sgOdaEQKeETkTSPeNO8xKZ9tXEvDMU1x3GEXSqa2ChZc0Mxo+xoUp832leYlqsd/rQSeA/
        hHXxknpMHBzvfs4Np
X-Received: by 2002:ac8:3f02:: with SMTP id c2mr14601026qtk.172.1575662224141;
        Fri, 06 Dec 2019 11:57:04 -0800 (PST)
X-Google-Smtp-Source: APXvYqxZt1ynXXvg1Q6Rg+BR8GgD1VE8dpn6UFzBpg+ntd8RuIsVWUlvn6Ns5zhUOQlFwasVOuMgqg==
X-Received: by 2002:ac8:3f02:: with SMTP id c2mr14600998qtk.172.1575662223931;
        Fri, 06 Dec 2019 11:57:03 -0800 (PST)
Received: from dhcp-10-20-1-90.bss.redhat.com ([144.121.20.162])
        by smtp.gmail.com with ESMTPSA id u12sm6896518qta.79.2019.12.06.11.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Dec 2019 11:57:03 -0800 (PST)
Message-ID: <ec3e020798d99ce638c05b0f3eb00ebf53c3bd7c.camel@redhat.com>
Subject: Re: [PATCH v2] drm/dp_mst: Remove VCPI while disabling topology mgr
From:   Lyude Paul <lyude@redhat.com>
To:     Wayne Lin <Wayne.Lin@amd.com>, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org
Cc:     Nicholas.Kazlauskas@amd.com, harry.wentland@amd.com,
        jerry.zuo@amd.com, stable@vger.kernel.org
Date:   Fri, 06 Dec 2019 14:57:01 -0500
In-Reply-To: <a6c4db964da7e00a6069d40abcb3aa887ef5522b.camel@redhat.com>
References: <20191205090043.7580-1-Wayne.Lin@amd.com>
         <a6c4db964da7e00a6069d40abcb3aa887ef5522b.camel@redhat.com>
Organization: Red Hat
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31)
MIME-Version: 1.0
X-MC-Unique: HXGKeKrEOU-Ov_gEmHJJJw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2019-12-06 at 14:24 -0500, Lyude Paul wrote:
> Reviewed-by: Lyude Paul <lyude@redhat.com>
> 
> I'll go ahead and push this to drm-misc-next-fixes right now, thanks!

Whoops-meant to say drm-misc-next here, anyway, pushed!
> 
> On Thu, 2019-12-05 at 17:00 +0800, Wayne Lin wrote:
> > [Why]
> > 
> > This patch is trying to address the issue observed when hotplug DP
> > daisy chain monitors.
> > 
> > e.g.
> > src-mstb-mstb-sst -> src (unplug) mstb-mstb-sst -> src-mstb-mstb-sst
> > (plug in again)
> > 
> > Once unplug a DP MST capable device, driver will call
> > drm_dp_mst_topology_mgr_set_mst() to disable MST. In this function,
> > it cleans data of topology manager while disabling mst_state. However,
> > it doesn't clean up the proposed_vcpis of topology manager.
> > If proposed_vcpi is not reset, once plug in MST daisy chain monitors
> > later, code will fail at checking port validation while trying to
> > allocate payloads.
> > 
> > When MST capable device is plugged in again and try to allocate
> > payloads by calling drm_dp_update_payload_part1(), this
> > function will iterate over all proposed virtual channels to see if
> > any proposed VCPI's num_slots is greater than 0. If any proposed
> > VCPI's num_slots is greater than 0 and the port which the
> > specific virtual channel directed to is not in the topology, code then
> > fails at the port validation. Since there are stale VCPI allocations
> > from the previous topology enablement in proposed_vcpi[], code will fail
> > at port validation and reurn EINVAL.
> > 
> > [How]
> > 
> > Clean up the data of stale proposed_vcpi[] and reset mgr->proposed_vcpis
> > to NULL while disabling mst in drm_dp_mst_topology_mgr_set_mst().
> > 
> > Changes since v1:
> > *Add on more details in commit message to describe the issue which the 
> > patch is trying to fix
> > 
> > Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
> > ---
> >  drivers/gpu/drm/drm_dp_mst_topology.c | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> > 
> > diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c
> > b/drivers/gpu/drm/drm_dp_mst_topology.c
> > index ae5809a1f19a..bf4f745a4edb 100644
> > --- a/drivers/gpu/drm/drm_dp_mst_topology.c
> > +++ b/drivers/gpu/drm/drm_dp_mst_topology.c
> > @@ -3386,6 +3386,7 @@ static int drm_dp_get_vc_payload_bw(u8 dp_link_bw,
> > u8  dp_link_count)
> >  int drm_dp_mst_topology_mgr_set_mst(struct drm_dp_mst_topology_mgr *mgr,
> > bool mst_state)
> >  {
> >  	int ret = 0;
> > +	int i = 0;
> >  	struct drm_dp_mst_branch *mstb = NULL;
> >  
> >  	mutex_lock(&mgr->lock);
> > @@ -3446,10 +3447,21 @@ int drm_dp_mst_topology_mgr_set_mst(struct
> > drm_dp_mst_topology_mgr *mgr, bool ms
> >  		/* this can fail if the device is gone */
> >  		drm_dp_dpcd_writeb(mgr->aux, DP_MSTM_CTRL, 0);
> >  		ret = 0;
> > +		mutex_lock(&mgr->payload_lock);
> >  		memset(mgr->payloads, 0, mgr->max_payloads * sizeof(struct
> > drm_dp_payload));
> >  		mgr->payload_mask = 0;
> >  		set_bit(0, &mgr->payload_mask);
> > +		for (i = 0; i < mgr->max_payloads; i++) {
> > +			struct drm_dp_vcpi *vcpi = mgr->proposed_vcpis[i];
> > +
> > +			if (vcpi) {
> > +				vcpi->vcpi = 0;
> > +				vcpi->num_slots = 0;
> > +			}
> > +			mgr->proposed_vcpis[i] = NULL;
> > +		}
> >  		mgr->vcpi_mask = 0;
> > +		mutex_unlock(&mgr->payload_lock);
> >  	}
> >  
> >  out_unlock:
-- 
Cheers,
	Lyude Paul

