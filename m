Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBF70310284
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 03:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbhBECCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 21:02:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbhBECCO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 21:02:14 -0500
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B320CC0613D6;
        Thu,  4 Feb 2021 18:01:34 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 56F1612806F8;
        Thu,  4 Feb 2021 18:01:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1612490492;
        bh=D07B0G2Q3u5JuWGOyZqEqTnrtgfD1PaA3n45mlDA+l8=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=mJPaUj42P4gcs1KP+2iN22vzTXRG/SiTFJmlrK7FwgbqjEd/ftmZ1fSfjo9TH+IYB
         zKzYgwNAKpICjmdEb80exJZFGx2v9J7ux4/j8rg4KOmqdwHaGSlSyBSNqxWAe3fCMP
         QWhMFD0U2Nu2W8/RcbWfDyKNqa/1VOsvJwFoW9T0=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id AEzeM8bIVfkt; Thu,  4 Feb 2021 18:01:32 -0800 (PST)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::c447])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id A3D2112806A9;
        Thu,  4 Feb 2021 18:01:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1612490492;
        bh=D07B0G2Q3u5JuWGOyZqEqTnrtgfD1PaA3n45mlDA+l8=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=mJPaUj42P4gcs1KP+2iN22vzTXRG/SiTFJmlrK7FwgbqjEd/ftmZ1fSfjo9TH+IYB
         zKzYgwNAKpICjmdEb80exJZFGx2v9J7ux4/j8rg4KOmqdwHaGSlSyBSNqxWAe3fCMP
         QWhMFD0U2Nu2W8/RcbWfDyKNqa/1VOsvJwFoW9T0=
Message-ID: <78f6bc5799c744dc3fdb2f508549cedf76ac1c1d.camel@HansenPartnership.com>
Subject: Re: [PATCH v3 1/2] tpm: fix reference counting for struct tpm_chip
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Stefan Berger <stefanb@linux.ibm.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>, peterhuewe@gmx.de,
        jarkko@kernel.org
Cc:     jgg@ziepe.ca, stefanb@linux.vnet.ibm.com, stable@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lino Sanfilippo <l.sanfilippo@kunbus.com>
Date:   Thu, 04 Feb 2021 18:01:30 -0800
In-Reply-To: <f5ad4381-773d-b994-51e5-a335ca4b44c3@linux.ibm.com>
References: <1612482643-11796-1-git-send-email-LinoSanfilippo@gmx.de>
         <1612482643-11796-2-git-send-email-LinoSanfilippo@gmx.de>
         <b36db793-9b40-92a8-19ef-4853ea10f775@linux.ibm.com>
         <f5ad4381-773d-b994-51e5-a335ca4b44c3@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2021-02-04 at 20:44 -0500, Stefan Berger wrote:
> To clarify: When I tested this I had *both* patches applied. Without
> the patches I got the null pointer exception in tpm2_del_space(). The
> 2nd patch alone solves that issue when using the steps above.


Yes, I can't confirm the bug either.  I only have lpc tis devices, so
it could be something to do with spi, but when I do

python3 in one shell

>>> fd = open("/dev/tpmrm0", "wb")

do rmmod tpm_tis in another shell

>>> buf = bytearray(20)
>>> fd.write(buf)
20

so I don't see the oops you see on write.  However

>>> fd.close()

And it oopses here in tpm2_del_space

James


