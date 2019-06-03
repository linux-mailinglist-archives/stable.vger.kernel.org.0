Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E597032B12
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 10:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfFCIrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 04:47:18 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38313 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbfFCIrR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 04:47:17 -0400
Received: by mail-qt1-f196.google.com with SMTP id l3so8422417qtj.5
        for <stable@vger.kernel.org>; Mon, 03 Jun 2019 01:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V9NE+rN0jgB/lXiphLpld1ARYp13HSE3NeSQuy+ddR0=;
        b=mPiK0RL4ZWEVEJXunuHexWMj8DmqM+eG/qBs02JpL37vyhXOhWwtbsb883b2uncK8T
         WiYmmcPANwwoz7CZvEFZmfiq4RWl9ecywLV9IZwZc1c/aob1Me98cqgVjrFpwqtvWlUL
         cc2PQeX0oleQtVnMoeo9dOJy5TfAScqihbE3z0k1YjTHsHgYgeMqJEcGgO/tYqrVXO6k
         NoQfcEU0N1Kn987zwfZOYJWJjMitvUsWYYrR9Jdx8cGXwSa4K4JzzmcmwyZpYMxqJOkn
         8/xdDPRNI7rFDI2ExJQoSJkZhhTCxfb/85qS59UZGAJ5Aul2TxrFShAmJl9ua//vLr1n
         hG1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V9NE+rN0jgB/lXiphLpld1ARYp13HSE3NeSQuy+ddR0=;
        b=TQdbLIBzKSVLrzrr87u6clcFw3XGPjKFyLadb+kna0udmOICboMgMsP3eWLzWdtgta
         yeQWk+9QbxDl+pmPrTEHQOpQ8xV8nRSg+v0NdzbCeX79E/JCJCtWLe2xAKMzgFehF700
         Cjtwy6rZYD5HTQ66Jo9LPxCJjkXkeXDmCWAKn+BvoZZVCKt5MHgRb+Vzo0MjW0HvlqLO
         8sNwQIMLasCCqSGCSrzeoqy3datEF+OT6OjAJUQz3radqiGUhIIrgtBl/tCWAOBUzlE+
         Ceo5ygfzhKyjVEQ0rxEGc5iGV/qqKTiwMidIgmBRAiZyvKV2QaxbglIh6x6y5DK3Gp4Y
         5kdA==
X-Gm-Message-State: APjAAAUMdf9tXBAxP/b2KbbgZb+FpmsFhk4o9A7oJ35qt+C3xniPBQV8
        2eFMC8lKP92CfCiK02FWIM73693guYv/xzpvK+KJ+Q==
X-Google-Smtp-Source: APXvYqyo1mkaeQ6Oac1t21mkBJbjfpyADMMuUhSQqX/YHfu0cWrvudOtKWn/T5TeuWCQIKT1eo+tGETLlmKK/S+OFX0=
X-Received: by 2002:a0c:b032:: with SMTP id k47mr20952534qvc.86.1559551636886;
 Mon, 03 Jun 2019 01:47:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190603082725.7255-1-jian-hong@endlessm.com>
In-Reply-To: <20190603082725.7255-1-jian-hong@endlessm.com>
From:   Daniel Drake <drake@endlessm.com>
Date:   Mon, 3 Jun 2019 16:47:05 +0800
Message-ID: <CAD8Lp468gEZ3A_o4YAcrn185=8yG=ezGptb21QSBCDQxzH07Zw@mail.gmail.com>
Subject: Re: [PATCH 5.1 stable] drm/i915: Force 2*96 MHz cdclk on glk/cnl when
 audio power is enabled
To:     Jian-Hong Pan <jian-hong@endlessm.com>
Cc:     stable@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Linux Upstreaming Team <linux@endlessm.com>,
        =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Abhay Kumar <abhay.kumar@intel.com>,
        Imre Deak <imre.deak@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 3, 2019 at 4:27 PM Jian-Hong Pan <jian-hong@endlessm.com> wrote:
>  static void i915_audio_component_get_power(struct device *kdev)
>  {
> -       intel_display_power_get(kdev_to_i915(kdev), POWER_DOMAIN_AUDIO);
> +       struct drm_i915_private *dev_priv = kdev_to_i915(kdev);
> +
> +       intel_display_power_get(dev_priv, POWER_DOMAIN_AUDIO);
> +
> +       /* Force CDCLK to 2*BCLK as long as we need audio to be powered. */
> +       if (dev_priv->audio_power_refcount++ == 0)
> +               if (IS_CANNONLAKE(dev_priv) || IS_GEMINILAKE(dev_priv))
> +                       glk_force_audio_cdclk(dev_priv, true);
>  }
>
>  static void i915_audio_component_put_power(struct device *kdev)
>  {
> -       intel_display_power_put_unchecked(kdev_to_i915(kdev),
> -                                         POWER_DOMAIN_AUDIO);
> +       struct drm_i915_private *dev_priv = kdev_to_i915(kdev);
> +       intel_wakeref_t cookie;
> +
> +       /* Stop forcing CDCLK to 2*BCLK if no need for audio to be powered. */
> +       if (--dev_priv->audio_power_refcount == 0)
> +               if (IS_CANNONLAKE(dev_priv) || IS_GEMINILAKE(dev_priv))
> +                       glk_force_audio_cdclk(dev_priv, false);
> +
> +       cookie = intel_display_power_get(dev_priv, POWER_DOMAIN_AUDIO);
> +       intel_display_power_put(dev_priv, POWER_DOMAIN_AUDIO, cookie);
>  }

The code above is the rediffed part of the patch. I think the last 2
lines here are not quite right.

Here, get means "increment reference count" and put means "decrease
reference count".

Before your patch, i915_audio_component_get_power() does
intel_display_power_get(), and i915_audio_component_put_power() does
intel_display_power_put_unchecked(). You can see the symmetry.

After your patch, i915_audio_component_get_power() does
intel_display_power_get() as before (good), but
i915_audio_component_put_power() does a 2nd get and then a single put.
So the reference count is now unbalanced.

I think the last 2 lines of this function should just be left the same
as they were before:
       intel_display_power_put_unchecked(kdev_to_i915(kdev),
                                         POWER_DOMAIN_AUDIO);

Daniel
