Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA411688091
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 15:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjBBOwf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 09:52:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbjBBOwd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 09:52:33 -0500
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CD49189B;
        Thu,  2 Feb 2023 06:52:12 -0800 (PST)
Received: by mail-ej1-f47.google.com with SMTP id bk15so6608199ejb.9;
        Thu, 02 Feb 2023 06:52:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tVkiy6fyJJUhDInSdWKIu6TvOC7zzv+pfj7iyuJ54pw=;
        b=IpFgN+D3kL7+KjME3WA0ulQviVq9E2haqALso/OUneyoDz4raI0hMDiaCAKgr2RUFO
         8jxxsEVZ8TO5PI/Gm0h9UIafOspjtOuRdjGe4DVulyL/Uz06PAQmKJ5MOkOHXC4XnFW1
         siz9Fdn58NG2DxzrdiFSwmvEo+74XW5QvKyUVZmIgJaP/gSe4M2TFj9pqvnNSSCpRCGC
         /HILpgK4gwpWWcJBTjAynxTxtn53AWDcXnJ2aYtITVAAJ0iEgKfBqhMjPnZ28bE9Zv6R
         mAH5EEnAYEgOLG2UMRIiEPO7wDO+w8swEnzylbTVbwq3Scq1JFzw+zuw9AJLxQQuzq1h
         VsSg==
X-Gm-Message-State: AO0yUKWWyVVt03/b54YSfTyQ6+MNAzqu+BWDQZmApWui6qugCI2NShZ9
        yibOEBImszXr2dyJ8fMa3CilSLSsriWKAKTOY9s=
X-Google-Smtp-Source: AK7set+Xeo3VH6AqENA2DUWa329xs2MKj1F6DptSOSs4aJYIWKjbeDoLprtbeYnT8dZpggmhpU34CqORZoTc33ZMDfA=
X-Received: by 2002:a17:906:85c7:b0:878:581b:63ee with SMTP id
 i7-20020a17090685c700b00878581b63eemr1733284ejy.244.1675349499550; Thu, 02
 Feb 2023 06:51:39 -0800 (PST)
MIME-Version: 1.0
References: <20230201203941.2166530-1-srinivas.pandruvada@linux.intel.com>
In-Reply-To: <20230201203941.2166530-1-srinivas.pandruvada@linux.intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 2 Feb 2023 15:51:28 +0100
Message-ID: <CAJZ5v0jGJ_UVGYaEk=guv5q4N7axGAJJyTwtraY9zFaBjs9Ejw@mail.gmail.com>
Subject: Re: [PATCH v2] thermal: intel_powerclamp: Fix cur_state for multi
 package system
To:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc:     rafael@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, daniel.lezcano@linaro.org,
        rui.zhang@intel.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 1, 2023 at 9:39 PM Srinivas Pandruvada
<srinivas.pandruvada@linux.intel.com> wrote:
>
> The powerclamp cooling device cur_state shows actual idle observed by
> package C-state idle counters. But the implementation is not sufficient
> for multi package or multi die system. The cur_state value is incorrect.
> On these systems, these counters must be read from each package/die and
> somehow aggregate them. But there is no good method for aggregation.
>
> It was not a problem when explicit CPU model addition was required to
> enable intel powerclamp. In this way certain CPU models could have
> been avoided. But with the removal of CPU model check with the
> availability of Package C-state counters, the driver is loaded on most
> of the recent systems.
>
> For multi package/die systems, just show the actual target idle state,
> the system is trying to achieve. In powerclamp this is the user set
> state minus one.
>
> Also there is no use of starting a worker thread for polling package
> C-state counters and applying any compensation for multiple package
> or multiple die systems.
>
> Fixes: b721ca0d1927 ("thermal/powerclamp: remove cpu whitelist")
> Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> Cc: stable@vger.kernel.org # 4.14+
> ---
> v2:
> Changed: (true == clamping) to (clamping)
> Updated commit description for the last paragraph
>
>  drivers/thermal/intel/intel_powerclamp.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/thermal/intel/intel_powerclamp.c b/drivers/thermal/intel/intel_powerclamp.c
> index b80e25ec1261..2f4cbfdf26a0 100644
> --- a/drivers/thermal/intel/intel_powerclamp.c
> +++ b/drivers/thermal/intel/intel_powerclamp.c
> @@ -57,6 +57,7 @@
>
>  static unsigned int target_mwait;
>  static struct dentry *debug_dir;
> +static bool poll_pkg_cstate_enable;
>
>  /* user selected target */
>  static unsigned int set_target_ratio;
> @@ -261,6 +262,9 @@ static unsigned int get_compensation(int ratio)
>  {
>         unsigned int comp = 0;
>
> +       if (!poll_pkg_cstate_enable)
> +               return 0;
> +
>         /* we only use compensation if all adjacent ones are good */
>         if (ratio == 1 &&
>                 cal_data[ratio].confidence >= CONFIDENCE_OK &&
> @@ -519,7 +523,8 @@ static int start_power_clamp(void)
>         control_cpu = cpumask_first(cpu_online_mask);
>
>         clamping = true;
> -       schedule_delayed_work(&poll_pkg_cstate_work, 0);
> +       if (poll_pkg_cstate_enable)
> +               schedule_delayed_work(&poll_pkg_cstate_work, 0);
>
>         /* start one kthread worker per online cpu */
>         for_each_online_cpu(cpu) {
> @@ -585,11 +590,15 @@ static int powerclamp_get_max_state(struct thermal_cooling_device *cdev,
>  static int powerclamp_get_cur_state(struct thermal_cooling_device *cdev,
>                                  unsigned long *state)
>  {
> -       if (true == clamping)
> -               *state = pkg_cstate_ratio_cur;
> -       else
> +       if (clamping) {
> +               if (poll_pkg_cstate_enable)
> +                       *state = pkg_cstate_ratio_cur;
> +               else
> +                       *state = set_target_ratio;
> +       } else {
>                 /* to save power, do not poll idle ratio while not clamping */
>                 *state = -1; /* indicates invalid state */
> +       }
>
>         return 0;
>  }
> @@ -712,6 +721,9 @@ static int __init powerclamp_init(void)
>                 goto exit_unregister;
>         }
>
> +       if (topology_max_packages() == 1 && topology_max_die_per_package() == 1)
> +               poll_pkg_cstate_enable = true;
> +
>         cooling_dev = thermal_cooling_device_register("intel_powerclamp", NULL,
>                                                 &powerclamp_cooling_ops);
>         if (IS_ERR(cooling_dev)) {
> --

Applied as 6.3 material, thanks!
