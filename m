Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91ED16B212D
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 11:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbjCIKTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 05:19:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbjCIKSc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 05:18:32 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58DA8E777C;
        Thu,  9 Mar 2023 02:17:43 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id e13so1293259wro.10;
        Thu, 09 Mar 2023 02:17:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678357062;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ei4d/Hmizeu+n/ueai/3+zUduZMkMcm7IOWBgH6XUwg=;
        b=jtF19SjrQ2ZnnS/VkBcagucubYd3QhkLjfPICAuRyhCCZrLcbEbZtAfO01ejnyfH3l
         QwL0fj194Ysw9ILJ26IDZ+MQKoZJwK0ZeXN1RGTTQEoTK0WVd1S1ZzIGGsYkgA21EH3w
         gZtOfBqH3qvuVea6741/i33gDc4vf7Sn/798eARMcjJHOyKyf/LDB2Of0uTEpFLDU+3b
         hHYQ18tV6yJthznfU2LKXHrO76/6SClemUqoO6PoI62rISm8A8sP1pxFyCDU4kLWYqic
         g5ndDOyUlk8wsv4vKfvlTQM/V+12U5vTsjfEBa0SX/C9xXMIRrkWPOMH81gt+62T4qGA
         tnrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678357062;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ei4d/Hmizeu+n/ueai/3+zUduZMkMcm7IOWBgH6XUwg=;
        b=UoTLHxPX1ysgQCz6nYN0bYJ2OtZlbwz7TTM5HXL6PCMbD4lOWrDhsApuAXgDjVSmUs
         oqzNS/5Mc9foEigpQCrXIGbi/u4MFkHu48Y04coBQ0v0MzxzY+v7c4BXY3dUqmWOmQJj
         K7E2RwkJZVVsWN6KpAJUBvSOiLW4/mLQesxWjBCrG55KADa9Tndi7w5W0e9LcDVj4b4v
         +NShrmjbLVCOFvORWFnCMHyPXloAHZrfVzWcHVCQa8kcVR88WWNagel3DxoWn2QLM1so
         GnlbNOCswhgJyCUxpq2hRkYNgqzg22o9iRln+mW9ykIhqL83PCu54N6yeCzDgzJwq86w
         70tg==
X-Gm-Message-State: AO0yUKVK+eTIvbm8QiddkGiNdpMf/MZZhscoiLDsvJQ0lFHsfNLNUMIb
        7Sj+Gty34aUb7BJcsamXT7oYMwMYle3EZdCYsQc=
X-Google-Smtp-Source: AK7set+ZrxJvLVeV/sFGeh0W8mNRe71nuRKvMyi01xVFUqu2ULnraAle1bms3bNDDUHS5K0Jr21Jj6ByaR6eexi0qSA=
X-Received: by 2002:a5d:540e:0:b0:2c7:a525:5d19 with SMTP id
 g14-20020a5d540e000000b002c7a5255d19mr4064232wrv.10.1678357061671; Thu, 09
 Mar 2023 02:17:41 -0800 (PST)
MIME-Version: 1.0
References: <CACH9xG8-tEtWstUVmD9eZFEEAqx-E8Gs14wDL+=uNtBK=-KJvQ@mail.gmail.com>
 <ZAmv57xeNqs7v9hY@kroah.com>
In-Reply-To: <ZAmv57xeNqs7v9hY@kroah.com>
From:   Sylvain Menu <sylvain.menu@gmail.com>
Date:   Thu, 9 Mar 2023 11:17:30 +0100
Message-ID: <CACH9xG9=BFszD9OXspttTFdki0e68b5Hw7o11AUQ7pptSMy9wQ@mail.gmail.com>
Subject: Re: nfs mount disappears due to inode revalidate failure
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        chuck.lever@oracle.com, jlayton@kernel.org,
        linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I think it's a regression according to the old resolved bugs/tickets
but no idea since when it's broken again

Le jeu. 9 mars 2023 =C3=A0 11:07, Greg KH <gregkh@linuxfoundation.org> a =
=C3=A9crit :
>
> On Thu, Mar 09, 2023 at 10:42:41AM +0100, Sylvain Menu wrote:
> > Hello,
> >
> > I am writing to report an issue on a nfs mount that disappears due to
> > an inode revalide failure (already sent in January but probably banned
> > with html format...).
> > This very old commit
> > (https://github.com/torvalds/linux/commit/cc89684c9a265828ce061037f1f79=
f4a68ccd3f7)
> > exactly show the problem I have and this old resolved issue
> > (https://bugzilla.kernel.org/show_bug.cgi?id=3D117651) is probably
> > failing again today
> >
> > To sum up, I have a NFS mount inside another NFS mount (for example:
> > /opt/nfs/mount1 & /opt/nfs/mount1/mount2).
> > If I kill a task trying to get a file descriptor on
> > /opt/nfs/mount1/mount2 then it will be unmounted. My simple test code
> > to reproduce very easily:
> >
> > int main(int argc, char *argv[]) {
> >     while (1) {
> >         close(open(argv[1], O_RDONLY));
> >     }
> > }
> >
> > In logs, I have: "nfs_revalidate_inode: (0:62/845965) getattr failed,
> > error=3D-512"
> >
> > Tested on 5.19 and 6.1 kernel
>
> So is this a regression or something that has always been present?
>
> thanks,
>
> greg k-h
