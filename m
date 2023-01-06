Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEE646608A7
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 22:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbjAFVPB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 16:15:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjAFVPA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 16:15:00 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1506A81C30
        for <stable@vger.kernel.org>; Fri,  6 Jan 2023 13:14:59 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id g20so1993656pfb.3
        for <stable@vger.kernel.org>; Fri, 06 Jan 2023 13:14:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CwOLnK2ifzFuyr165LNzqz5GnvMFyliD+SS3u04GcaQ=;
        b=fQ3uOApcxQR/IsZivYDkfhBOj3GhwFU3tAsLTFuEVAPRPR10Inv7wS4kVorYVsJLlG
         8n0xE/1sTmVOH0hu+adBfEjI8JaSxtmQsvOScWoHbuCb/zC7iXJRmVjUi/zMHRyp1Woj
         aIkxixCOv2op1sVjyL0pqY0STzhYHHIKifcn+SV2YQ7lkhVjAP0pQ0BDvW7rWSaf9BcM
         FbrWjT1sIdJKfH5SiffG/z0ZWEfSoZqDaCViQqjeNsv5lVZHXzUN/xFq4XiDMSOWk69M
         Dl+f8JPEzAA1dBCgkT8/ssw8M92FVA43pnEzRE7ZHzoxOquhEfiJ7M967D5W8gGtWKtV
         vDKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CwOLnK2ifzFuyr165LNzqz5GnvMFyliD+SS3u04GcaQ=;
        b=PQJYyHUbvffXgSsSjED5GEz8NcJ/zQIEtBp10Jje2oKhDzRjbjYym0tf6YIL20dztU
         cIOEtYPsHg0nBxV7G1dWd5g9cx2toaycD4810P/nOevRdtiNgpFu86JfVutacH/Ug0Aa
         /K0kCOoWmMwWsin3LyooRm5rMqoF2deVCjG7eqDFblwBD2safSwiw1aASsawnETcCsgz
         WNK8t0yY5H5vsR4JggnwB8VCce+ORSA/9X27idR2MvmWfVAAM1yOw9d8U/Wj0mZA58LK
         Kkyhts9yN/UWf0leym5tJfhNBaioBNDs44eF+L8RzAi1voKF1+y88bx4wzM5ZDv4hoNo
         ejsA==
X-Gm-Message-State: AFqh2kojsMiaUZ/D+VqjJSm294UaTUP03BLVd9XQSY3Pm9JYpkYzosfN
        qrZgtL5mQbPDIDIQp6faNxnGQzJOWE301azgux7fKghMgzZ0KYE=
X-Google-Smtp-Source: AMrXdXunbq8svWmpL5uzJpDIG9dH1bnChWXrVS5uoNEeJGgqDMuv7i47INaTjXl1feUFwaMf91aGmisI+GELaFzB0V8=
X-Received: by 2002:a05:6a00:1345:b0:582:5f1a:97c2 with SMTP id
 k5-20020a056a00134500b005825f1a97c2mr1477126pfu.3.1673039698452; Fri, 06 Jan
 2023 13:14:58 -0800 (PST)
MIME-Version: 1.0
References: <20221221141007.2579770-1-roberto.sassu@huaweicloud.com>
In-Reply-To: <20221221141007.2579770-1-roberto.sassu@huaweicloud.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 6 Jan 2023 16:14:47 -0500
Message-ID: <CAHC9VhQUAuF-Fan72j7BOqOdLE=B=mJpJ_GpR5p5cUmXruYT=Q@mail.gmail.com>
Subject: Re: [PATCH v2] security: Restore passing final prot to ima_file_mmap()
To:     Roberto Sassu <roberto.sassu@huaweicloud.com>, zohar@linux.ibm.com
Cc:     jmorris@namei.org, serge@hallyn.com,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        Roberto Sassu <roberto.sassu@huawei.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 21, 2022 at 9:10 AM Roberto Sassu
<roberto.sassu@huaweicloud.com> wrote:
>
> From: Roberto Sassu <roberto.sassu@huawei.com>
>
> Commit 98de59bfe4b2f ("take calculation of final prot in
> security_mmap_file() into a helper") moved the code to update prot with the
> actual protection flags to be granted to the requestor by the kernel to a
> helper called mmap_prot(). However, the patch didn't update the argument
> passed to ima_file_mmap(), making it receive the requested prot instead of
> the final computed prot.
>
> A possible consequence is that files mmapped as executable might not be
> measured/appraised if PROT_EXEC is not requested but subsequently added in
> the final prot.
>
> Replace prot with mmap_prot(file, prot) as the second argument of
> ima_file_mmap() to restore the original behavior.
>
> Cc: stable@vger.kernel.org
> Fixes: 98de59bfe4b2 ("take calculation of final prot in security_mmap_file() into a helper")
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> ---
>  security/security.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/security/security.c b/security/security.c
> index d1571900a8c7..0d2359d588a1 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -1666,7 +1666,7 @@ int security_mmap_file(struct file *file, unsigned long prot,
>                                         mmap_prot(file, prot), flags);
>         if (ret)
>                 return ret;
> -       return ima_file_mmap(file, prot);
> +       return ima_file_mmap(file, mmap_prot(file, prot));
>  }

This seems like a reasonable fix, although as the original commit is
~10 years old at this point I am a little concerned about the impact
this might have on IMA.  Mimi, what do you think?

Beyond that, my only other comment would be to only call mmap_prot()
once and cache the results in a local variable.  You could also fix up
some of the ugly indentation crimes in security_mmap_file() while you
are at it, e.g. something like this:

diff --git a/security/security.c b/security/security.c
index d1571900a8c7..2f9cad9ecac8 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1662,11 +1662,12 @@ int security_mmap_file(struct file *file, unsigned long
prot,
                       unsigned long flags)
{
       int ret;
-       ret = call_int_hook(mmap_file, 0, file, prot,
-                                       mmap_prot(file, prot), flags);
+       unsigned long prot_adj = mmap_prot(file, prot);
+
+       ret = call_int_hook(mmap_file, 0, file, prot, prot_adj, flags);
       if (ret)
               return ret;
-       return ima_file_mmap(file, prot);
+       return ima_file_mmap(file, prot_adj);
}

--
paul-moore.com
