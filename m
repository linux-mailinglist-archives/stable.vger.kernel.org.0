Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF9E7A7C09
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 08:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbfIDGwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 02:52:51 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50038 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfIDGwv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Sep 2019 02:52:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=8+Tz9OEyS9QHNKEZCjFkVYuXIZ9nDtNfSpQQaZMpkYw=; b=jh3AJU6yeiKy5JwDvUyHb5gN+
        23Rtt4b2yENW0uhMKj5SPKIhTMrCPEP/UdrgS3Q/+pqxHq3DafH6/zSDmhXFw5ms/n8Q1cm72uSOd
        lfkd5wCQTSWfjORJjacJYCDqQ9cfXOcjhneXZy0hOHCVVmvwEliClHHx+p8nHrx3I6dM3vzeWkIA5
        Ust/WBsXrXQ2bFdSFJTimi7QOVadTsSIfcbPEjt7Y+tx6iwDqFj4s7t2Rl0wcskrI1cPETSqY8Oc8
        fw2WX8I7aGpmXQStqqivWcDSsnY5GS2qCA9x4a1cVGR+AjoTMraN0Wp+jU2dMwn1OCAqt6Poc7oSn
        b3/GnFL5g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i5P9q-0006RZ-CX; Wed, 04 Sep 2019 06:52:46 +0000
Date:   Tue, 3 Sep 2019 23:52:46 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Mike Travis <mike.travis@hpe.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Russ Anderson <russ.anderson@hpe.com>,
        Hedi Berriche <hedi.berriche@hpe.com>,
        Steve Wahl <steve.wahl@hpe.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 8/8] x86/platform/uv: Account for UV Hubless in
 is_uvX_hub Ops
Message-ID: <20190904065246.GB18003@infradead.org>
References: <20190903001815.504418099@stormcage.eag.rdlabs.hpecorp.net>
 <20190903001816.705097213@stormcage.eag.rdlabs.hpecorp.net>
 <20190903161917.GA23281@infradead.org>
 <98e34464-f9b7-6e78-6528-96b83f094282@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98e34464-f9b7-6e78-6528-96b83f094282@hpe.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 03, 2019 at 11:58:49AM -0700, Mike Travis wrote:
> Those ifdefs are not dead code and are being actively used.  Plus UV1
> support is dead and I think the last running system died about a year ago
> and no support or parts are available.  So undef'ing these macros will
> simplify and reduce the size of the object code.

I'm not complaining about removing some ifdefs, that is always good.
I complain about keeping the others that are dead.  And if Hub 1 is
dead please drop all the checks and support code for it.

A patch against current mainline to show what I mean is below.

---
From e84506399fa9436d47b33491d3e38e9dc3c718c7 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Tue, 3 Sep 2019 18:05:37 +0200
Subject: x86/uv: Remove the dead UV?_HUB_IS_SUPPORTED defines

These are always set, so remove them and the dead code for the case
where they are not defined.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/x86/include/asm/uv/uv_hub.h  | 38 -------------------------------
 arch/x86/include/asm/uv/uv_mmrs.h |  7 ------
 2 files changed, 45 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
index 6eed0b379412..f71eb659f0de 100644
--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -229,68 +229,33 @@ static inline struct uv_hub_info_s *uv_cpu_hub_info(int cpu)
 #define UV4_HUB_REVISION_BASE		7
 #define UV4A_HUB_REVISION_BASE		8	/* UV4 (fixed) rev 2 */
 
-#ifdef	UV1_HUB_IS_SUPPORTED
 static inline int is_uv1_hub(void)
 {
 	return uv_hub_info->hub_revision < UV2_HUB_REVISION_BASE;
 }
-#else
-static inline int is_uv1_hub(void)
-{
-	return 0;
-}
-#endif
 
-#ifdef	UV2_HUB_IS_SUPPORTED
 static inline int is_uv2_hub(void)
 {
 	return ((uv_hub_info->hub_revision >= UV2_HUB_REVISION_BASE) &&
 		(uv_hub_info->hub_revision < UV3_HUB_REVISION_BASE));
 }
-#else
-static inline int is_uv2_hub(void)
-{
-	return 0;
-}
-#endif
 
-#ifdef	UV3_HUB_IS_SUPPORTED
 static inline int is_uv3_hub(void)
 {
 	return ((uv_hub_info->hub_revision >= UV3_HUB_REVISION_BASE) &&
 		(uv_hub_info->hub_revision < UV4_HUB_REVISION_BASE));
 }
-#else
-static inline int is_uv3_hub(void)
-{
-	return 0;
-}
-#endif
 
 /* First test "is UV4A", then "is UV4" */
-#ifdef	UV4A_HUB_IS_SUPPORTED
 static inline int is_uv4a_hub(void)
 {
 	return (uv_hub_info->hub_revision >= UV4A_HUB_REVISION_BASE);
 }
-#else
-static inline int is_uv4a_hub(void)
-{
-	return 0;
-}
-#endif
 
-#ifdef	UV4_HUB_IS_SUPPORTED
 static inline int is_uv4_hub(void)
 {
 	return uv_hub_info->hub_revision >= UV4_HUB_REVISION_BASE;
 }
-#else
-static inline int is_uv4_hub(void)
-{
-	return 0;
-}
-#endif
 
 static inline int is_uvx_hub(void)
 {
@@ -302,10 +267,7 @@ static inline int is_uvx_hub(void)
 
 static inline int is_uv_hub(void)
 {
-#ifdef	UV1_HUB_IS_SUPPORTED
 	return uv_hub_info->hub_revision;
-#endif
-	return is_uvx_hub();
 }
 
 union uvh_apicid {
diff --git a/arch/x86/include/asm/uv/uv_mmrs.h b/arch/x86/include/asm/uv/uv_mmrs.h
index 62c79e26a59a..9ee5ed6e8b34 100644
--- a/arch/x86/include/asm/uv/uv_mmrs.h
+++ b/arch/x86/include/asm/uv/uv_mmrs.h
@@ -99,13 +99,6 @@
 #define UV3_HUB_PART_NUMBER_X	0x4321
 #define UV4_HUB_PART_NUMBER	0x99a1
 
-/* Compat: Indicate which UV Hubs are supported. */
-#define UV1_HUB_IS_SUPPORTED	1
-#define UV2_HUB_IS_SUPPORTED	1
-#define UV3_HUB_IS_SUPPORTED	1
-#define UV4_HUB_IS_SUPPORTED	1
-#define UV4A_HUB_IS_SUPPORTED	1
-
 /* Error function to catch undefined references */
 extern unsigned long uv_undefined(char *str);
 
-- 
2.20.1

