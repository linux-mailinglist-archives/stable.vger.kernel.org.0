Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0336C508C0A
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 17:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354828AbiDTP1I convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 20 Apr 2022 11:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351566AbiDTP1H (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 11:27:07 -0400
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A8E45ADA;
        Wed, 20 Apr 2022 08:24:20 -0700 (PDT)
Received: by mail-yb1-f181.google.com with SMTP id b95so3512429ybi.1;
        Wed, 20 Apr 2022 08:24:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MWceczmjUO37YPGOpaCzlE2Zyz50+yuUdjcpMp0Klao=;
        b=J9AF9s6Pd1ZQ80L8NM8m6mXMwQNRfZnYZMxhb9DV/XpYBQXYNi4tSggZI9iPobDuxs
         mEeXEP4014nmIm+eFc2w2BjcQJRu3eodwzENT+uYvMqULne3ica1gA/mfVuhvuLHhhsc
         c4YL0t3l1sMKVkWIaU5xKyw51d3r5GU3s3aSMQFHMWNtvcN0qM/kgiR2BRMq+Ey82NEy
         JFGGqhS6gasi1t4dNWvgORZug2QLOn56MpmCVt8sW7yeL/FYsZdm2zswZfXzPq/4hCy7
         lVSG00j6h/atg5OBs+zFeJnG1kBc0o2d4ov0iiKhrmZt42Laipp3Pjf6WGbE7lUzY8fR
         DBVw==
X-Gm-Message-State: AOAM530d2jVNhOLgAp3AEMPg4xocOLl3Q6l/6UQzM1TTXzlq+FvK+9z7
        cD/QU1nnf+ZohHAkFzkd6vk1CLQNFi5tAI52gSbngSuIWAQ=
X-Google-Smtp-Source: ABdhPJzXVjGZVbhUklUBSihwA80GowN9dpk172WqM1FWGxil0M8njrswfqcur+9ptU35rJxkc4FLQJEp1xJ+T+kIT0s=
X-Received: by 2002:a25:ac9b:0:b0:641:3c32:bee7 with SMTP id
 x27-20020a25ac9b000000b006413c32bee7mr19051604ybi.633.1650468260183; Wed, 20
 Apr 2022 08:24:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220420134417.24546-1-ville.syrjala@linux.intel.com>
In-Reply-To: <20220420134417.24546-1-ville.syrjala@linux.intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 20 Apr 2022 17:24:09 +0200
Message-ID: <CAJZ5v0heJzWWio7m4-hO5j7q3fA-S6q6tXojJGsQ2rty-4hd2w@mail.gmail.com>
Subject: Re: [PATCH 1/2] ACPI: processor: Do not use C3 w/o ARB_DIS=1
To:     Ville Syrjala <ville.syrjala@linux.intel.com>
Cc:     ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, Stable <stable@vger.kernel.org>,
        Woody Suwalski <wsuwalski@gmail.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Richard Gong <richard.gong@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 20, 2022 at 3:44 PM Ville Syrjala
<ville.syrjala@linux.intel.com> wrote:
>
> From: Ville Syrjälä <ville.syrjala@linux.intel.com>
>
> commit d6b88ce2eb9d ("ACPI: processor idle: Allow playing dead in C3 state")
> was supposedly just trying to enable C3 when the CPU is offlined,
> but it also mistakenly enabled C3 usage without setting ARB_DIS=1
> in normal idle scenarios.
>
> This results in a machine that won't boot past the point when it first
> enters C3. Restore the correct behaviour (either demote to C1/C2, or
> use C3 but also set ARB_DIS=1).
>
> I hit this on a Fujitsu Siemens Lifebook S6010 (P3) machine.
>
> Cc: stable@vger.kernel.org
> Cc: Woody Suwalski <wsuwalski@gmail.com>
> Cc: Mario Limonciello <mario.limonciello@amd.com>
> Cc: Richard Gong <richard.gong@amd.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Fixes: d6b88ce2eb9d ("ACPI: processor idle: Allow playing dead in C3 state")
> Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> ---
>  drivers/acpi/processor_idle.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> index 4556c86c3465..54f0a1915025 100644
> --- a/drivers/acpi/processor_idle.c
> +++ b/drivers/acpi/processor_idle.c
> @@ -793,10 +793,10 @@ static int acpi_processor_setup_cstates(struct acpi_processor *pr)
>
>                 state->flags = 0;
>                 if (cx->type == ACPI_STATE_C1 || cx->type == ACPI_STATE_C2 ||
> -                   cx->type == ACPI_STATE_C3) {
> +                   cx->type == ACPI_STATE_C3)
>                         state->enter_dead = acpi_idle_play_dead;
> +               if (cx->type == ACPI_STATE_C1 || cx->type == ACPI_STATE_C2)
>                         drv->safe_state_index = count;
> -               }
>                 /*
>                  * Halt-induced C1 is not good for ->enter_s2idle, because it
>                  * re-enables interrupts on exit.  Moreover, C1 is generally not
> --

Good catch, but I would prefer doing the below which should be
equivalent (modulo GMail-induced white space breakage):

---
 drivers/acpi/processor_idle.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-pm/drivers/acpi/processor_idle.c
===================================================================
--- linux-pm.orig/drivers/acpi/processor_idle.c
+++ linux-pm/drivers/acpi/processor_idle.c
@@ -795,7 +795,8 @@ static int acpi_processor_setup_cstates(
         if (cx->type == ACPI_STATE_C1 || cx->type == ACPI_STATE_C2 ||
             cx->type == ACPI_STATE_C3) {
             state->enter_dead = acpi_idle_play_dead;
-            drv->safe_state_index = count;
+            if (cx->type != ACPI_STATE_C3)
+                drv->safe_state_index = count;
         }
         /*
          * Halt-induced C1 is not good for ->enter_s2idle, because it
