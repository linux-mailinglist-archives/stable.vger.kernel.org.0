Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5AB571F22
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 17:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbiGLP3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 11:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233612AbiGLP3Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 11:29:16 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624CB48EAA;
        Tue, 12 Jul 2022 08:29:15 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id y11so8009800lfs.6;
        Tue, 12 Jul 2022 08:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=33e1pQpo/cI3yeLaH9aFbJtUcPDdygTb7WbPIj6Y/9M=;
        b=cdSTWrZnF0Za3O2jVgaFuP91VEZVWYfve8J5n7+1yyHZzuDjwfTAnfyv24RtZUinNZ
         ztw+TJ7GIyVvGOI/GCvcuZAqr4ICF34YDAcFif7WX2BcAWhsT78f2m6hTRDs1Sd2LTqD
         Ttn4cm24kHiFdq780x+X4lPEl2HJwYGvQryLVOIdBrUL+EfdYRrx+X3jW6MBn/5PeQPE
         2suZeERDaZq9yoqTVBt3dO3QPGsNyoznmVVYwxZMAG86bmqZEDDcHzlg45TGA0rGydKs
         ag2l6GnguFx67kH3x6GnGkJQJ0jigW/wWYdfTHPcEbOvP2a4u78Fj+q9hDP1SiUNwrP1
         Z5xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=33e1pQpo/cI3yeLaH9aFbJtUcPDdygTb7WbPIj6Y/9M=;
        b=lMG3CuLtdmxSKOXIHx6AFVXfUHw6nyeEtvRzkVByKetZRdWO6znRTNeQFpbhVjSAmx
         cghyIk8cemNvNigXqoOoxRsP7fWO+AOrrwaPIoWmWiJnI3xRsd58n6/tJRaShq3WAi3h
         ZA22QFkpMJ5eXq+6XNU6WL8DbZK1E2XfWJcmuIbS78/P6bwcvPLcLa+wphYa6VFgIJpu
         ypi+Fg3ROa9u60D81NjuW8WqQtVCWOmB55NV6miWXYfldjIAA9j+WsNiYiLicOrQxRt/
         NbcNaDcAXnwPyW38cAG9b+KE2hRczkkR/iVYwbzf42uTRx/2d9hmT7LtnzTdRHJD6vaZ
         lasw==
X-Gm-Message-State: AJIora9V5aMg+4LFngbTKvIlYKQKlif20e6R/frbMikgWIN5G72ekJeF
        ZcLUWTzj4nJwfB9Y+A7sU/2Sl7zjKbJ2ywaNwPU=
X-Google-Smtp-Source: AGRyM1tpilKBmxNhH1xOJR+fwowMVDS2noX1nV3GZyEa8p5wldY40I+xYldyLCt6SZdN+WdHl1tGxzYnXl5QAVyZUzg=
X-Received: by 2002:a05:6512:a82:b0:483:6de9:4f18 with SMTP id
 m2-20020a0565120a8200b004836de94f18mr14758056lfu.447.1657639753602; Tue, 12
 Jul 2022 08:29:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220706164043.417780-1-jandryuk@gmail.com> <YsuRzGBss/lMG2+W@kernel.org>
 <CAKf6xpvY0Tj4HGpbshWonnpJLf_08+9pARONt2uHi-m92aqJmQ@mail.gmail.com>
In-Reply-To: <CAKf6xpvY0Tj4HGpbshWonnpJLf_08+9pARONt2uHi-m92aqJmQ@mail.gmail.com>
From:   Jason Andryuk <jandryuk@gmail.com>
Date:   Tue, 12 Jul 2022 11:29:02 -0400
Message-ID: <CAKf6xpsLCWhRixPtqGo=vQahPxK+Chg10tvyXhTRvkbLE0zxEQ@mail.gmail.com>
Subject: Re: [PATCH] tpm_tis: Hold locality open during probe
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Chen Jun <chenjun102@huawei.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        stable@vger.kernel.org, linux-integrity@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 11, 2022 at 3:37 PM Jason Andryuk <jandryuk@gmail.com> wrote:
>
> On Sun, Jul 10, 2022 at 10:58 PM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> >
> > Can you test against
> >
> > https://lore.kernel.org/linux-integrity/20220629232653.1306735-1-LinoSanfilippo@gmx.de/T/#t
>
> I applied on top of 5.15.53, and the probe on boot still fails.
> Manually probing works intermittently.

On top of Lino Sanfilippo's patch queue, I added an additional
tpm_tis_request_locality and tpm_tis_release_locality to hold the
locality open via refcount in tpm_tis_chip_init.  Similar to my patch
in this thread, it acquires the locality before the TPM_INT_ENABLE
write and holds it until after the TPM_RID read.  That fixes the probe
issue on the box where I tested.

While tpm_tis_core_init is definitely a problem, I wonder if there are
other code paths that could trigger this  acquire -> release ->
acquire issue.  In that light, restoring a wait by reverting commit
e42acf104d6e ("tpm_tis: Clean up locality release") seems safer since
it would cover any code path.  I just tested reverting that and it
still fails to probe on boot and intermittently.  I'm surprised since
I expected it to solve the issue, but my original debugging was
showing TPM_ACCESS_ACTIVE_LOCALITY cleared (and never re-set) so the
driver isn't actually waiting.

All this locality acquiring and releasing seems rather redundant.  If
locality 0 is all that is ever used, why not just hold it open?  I
guess Trench Boot/Secure Launch wants to use locality 2
(https://lore.kernel.org/lkml/1645070085-14255-13-git-send-email-ross.philipson@oracle.com/),
but in either case doesn't the system just stay in the assigned
locality?  I haven't read the spec, so maybe that is disallowed.
There is something nice about cleaning up and releasing the locality
when not in use, but it's also causing a problem here.

Regards,
Jason
