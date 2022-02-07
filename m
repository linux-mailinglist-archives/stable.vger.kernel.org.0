Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDC54AB80A
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 11:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350616AbiBGJvH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 04:51:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351343AbiBGJfz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 04:35:55 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889CDC043181;
        Mon,  7 Feb 2022 01:35:54 -0800 (PST)
Received: from zn.tnic (dslb-088-067-221-104.088.067.pools.vodafone-ip.de [88.67.221.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D93221EC032C;
        Mon,  7 Feb 2022 10:35:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1644226547;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=rDiVcxjeYIchdVruDF/dh+Lsn2pxySfwdTEN8yKfdeQ=;
        b=nnRw/Rwp2ohjKTUmnH9MBlX89ad3H/Y7vIsogbPEB2l6ApAnSms33M5oDEXH8rc92vQOFg
        PraSmUxtkbAd1G9jq0L51/yfllCBdkkq+nvvzspcZkcwGSbPtRBpsPNFrN8OkU0+JnqzTh
        F7ttl1pHCVXr19Tft2Dt548YWOGBeaU=
Date:   Mon, 7 Feb 2022 10:35:41 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     luofei <luofei@unicloud.com>, stable@vger.kernel.org,
        tony.luck@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/mm, mm/hwpoison: fix unmap kernel 1:1 pages
Message-ID: <YgDn7WWdcD5xaprX@zn.tnic>
References: <20220207075242.830685-1-luofei@unicloud.com>
 <YgDU3+KsiaQ54J5N@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YgDU3+KsiaQ54J5N@kroah.com>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        TRACKER_ID,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 07, 2022 at 09:14:23AM +0100, Greg KH wrote:
> On Mon, Feb 07, 2022 at 02:52:42AM -0500, luofei wrote:
> > Only unmap the page when the memory error is properly handled
> > by calling memory_failure(), not the other way around.
> > 
> > Fixes: 26f8c38bb466("x86/mm, mm/hwpoison: Don't unconditionally unmap kernel 1:1 pages")
> 
> This commit is not in Linus's tree.  Please use the correct commit id.

I think he's trying to fix the backport:

see 26f8c38bb466c1a2d232d7609fb4bfb4bc121678 which is the stable tree backport:

@@ -582,7 +586,8 @@ static int srao_decode_notifier(struct notifier_block *nb, unsigned long val,
 
        if (mce_usable_address(mce) && (mce->severity == MCE_AO_SEVERITY)) {
                pfn = mce->addr >> PAGE_SHIFT;
-               memory_failure(pfn, MCE_VECTOR, 0);
+               if (memory_failure(pfn, MCE_VECTOR, 0))
+                       mce_unmap_kpfn(pfn);
        }


vs the upstream commit:

fd0e786d9d09024f67bd71ec094b110237dc3840

@@ -590,7 +594,8 @@ static int srao_decode_notifier(struct notifier_block *nb, unsigned long val,
 
        if (mce_usable_address(mce) && (mce->severity == MCE_AO_SEVERITY)) {
                pfn = mce->addr >> PAGE_SHIFT;
-               memory_failure(pfn, 0);
+               if (!memory_failure(pfn, 0))
+                       mce_unmap_kpfn(pfn);
        }
 
        return NOTIFY_OK;

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
