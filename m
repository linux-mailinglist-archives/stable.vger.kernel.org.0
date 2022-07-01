Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25D6D5633A1
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 14:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236227AbiGAMpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 08:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236215AbiGAMpJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 08:45:09 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B745533EB4;
        Fri,  1 Jul 2022 05:45:06 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id l81so3337472oif.9;
        Fri, 01 Jul 2022 05:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9fESupLsVibFBT9Jshx7sx492QNW1uXVHiFs4UY6jdo=;
        b=B5NGKiRmAEpLNLEvQvABrUY2mlRFTJIghKa0CmaEprTgUg8P/bMLjDlC9kqySWbxX3
         WbtV6Ly41oBeo7+bnVMbiOCtsCj+s21zCMaKWHKIFpxWvbGvSRgkZytYo2CDJHWX7CQy
         H0Lo4IVoOLp0brhFmh1VLK5kNnbeepwvvprEWGPfumaQIQrTiQQpS1U3eI8UUCyg5qNj
         rgDb2Uz9eLivrzgiR8dVP7NnivyIN7GwoT1+hvhiT42KM1qYWy4gvv0dLWk3Bk9eqgfm
         vR0MqGdvIWq1A1Yz9vzd5RFkRMmaDB1AviyZo68aMlrOWiSCDjzcIXUTQ31msC+JBIbK
         jC6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9fESupLsVibFBT9Jshx7sx492QNW1uXVHiFs4UY6jdo=;
        b=RtRLlPWyj3U/tlpw3Sz/bZ18Rx4FJnhzZwvTHLYx7AiQudjsXkpDMP3oOXLgTFD7IK
         wQs2NcDoIz2sOEv/xOAy/BGL8bMKobMbIDPz9fjMS3sZf+g8H3vVnzqYFszLMhP/cIJA
         xU5fvGAaZT4KsbH9w8m7ED6MtdakBlB1Cw00g/AZxTq1IyIAm8qWRbeCpjH8WpVsvMda
         ONnn+oTtpI8BICbroZuKIYtoIJU3/+ARr+A2mr0RE7GT920p19RlhNyuOxOAr/fWve+p
         RAj9vEuSg0Rf/1hrjBXcXxNBlQMPn2DLKxOc4AskmYDkqBiKXMqoh2ipBKNZq692uhNY
         K3NA==
X-Gm-Message-State: AJIora9uuE48gTxHrdkLlqS2sUlwQzVB2l7uT/nxyTE8XClkkWN3W7Lj
        392DULjbvSTfRZZc4Tiz2O78NGbO1Tk0HXUW/AGtRUfJTQ2sOA==
X-Google-Smtp-Source: AGRyM1uoR9RgXLNVs7iXQWGsEnvNo3LHdrJfhjDPo9OILGpE6veZNJc15raUa4vJXNYHDVShVhEAd7LSwSk5Ktr9zIc=
X-Received: by 2002:a05:6808:30a8:b0:335:afc9:4a2c with SMTP id
 bl40-20020a05680830a800b00335afc94a2cmr7811673oib.288.1656679505945; Fri, 01
 Jul 2022 05:45:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220630022317.15734-1-gch981213@gmail.com> <b84edc24-0a3a-a4d2-6481-fb3d4cee6dda@amd.com>
In-Reply-To: <b84edc24-0a3a-a4d2-6481-fb3d4cee6dda@amd.com>
From:   Chuanhong Guo <gch981213@gmail.com>
Date:   Fri, 1 Jul 2022 20:44:54 +0800
Message-ID: <CAJsYDVL=fgExYdw3JB-59rCwOqTbSt2N0Xw2WCmoTSzOQEMRRg@mail.gmail.com>
Subject: Re: [PATCH v5] ACPI: skip IRQ1 override on 3 Ryzen 6000 laptops
To:     "Rafael J. Wysocki" <rafael@kernel.org>,
        "Limonciello, Mario" <mario.limonciello@amd.com>
Cc:     linux-acpi@vger.kernel.org, stable@vger.kernel.org,
        Tighe Donnelly <tighe.donnelly@protonmail.com>,
        Kent Hou Man <knthmn0@gmail.com>,
        Len Brown <lenb@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 1, 2022 at 4:12 AM Limonciello, Mario
<mario.limonciello@amd.com> wrote:
> However I do want to point out that Windows doesn't care about legacy
> format or not.  This bug where keyboard doesn't work only popped up on
> Linux.
>
> Given the number of systems with the bug is appearing to grow I wonder
> if the right answer is actually a new heuristic that doesn't apply the
> kernel override for polarity inversion anymore.  Maybe if the system is
> 2022 or newer?  Or on the ACPI version?

The previous attempt to limit the scope of IRQ override ends up
breaking some other buggy devices:
https://patchwork.kernel.org/project/linux-acpi/patch/20210728151958.15205-1-hui.wang@canonical.com/

It's unfortunate that the original author of this IRQ override doesn't
limit the scope to their exact devices.

Hi, Rafael! What do you think? should we skip this IRQ override
one-by-one or add a different matching logic to check the bios date
instead?

-- 
Regards,
Chuanhong Guo
