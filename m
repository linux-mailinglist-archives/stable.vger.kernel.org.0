Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8672F16D2
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730500AbhAKN5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:57:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:54252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730394AbhAKNG5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:06:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E452E22AAF;
        Mon, 11 Jan 2021 13:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370401;
        bh=PSJJeZbr+lK0GCebJ9clBwB5PAAtK4YdfQoHGi7zZiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Th/Mx3GgrxOf6hQvxqLCTOKPDqgSDfAQnn004pyd4TSxINvRl3Rk9l5+hZUEEOLzx
         jfQTA+JuYq+H6kyJ7visgiKyTEDSlLaXTbeOFpLNHFLJZKs43JxXEkr7Q2o5RwYaad
         FIwJA6MROA7pnSledxmG4lPa6rER2mA8ILfuH2No=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ying-Tsun Huang <ying-tsun.huang@amd.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 4.14 56/57] x86/mtrr: Correct the range check before performing MTRR type lookups
Date:   Mon, 11 Jan 2021 14:02:15 +0100
Message-Id: <20210111130036.438085698@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130033.715773309@linuxfoundation.org>
References: <20210111130033.715773309@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ying-Tsun Huang <ying-tsun.huang@amd.com>

commit cb7f4a8b1fb426a175d1708f05581939c61329d4 upstream.

In mtrr_type_lookup(), if the input memory address region is not in the
MTRR, over 4GB, and not over the top of memory, a write-back attribute
is returned. These condition checks are for ensuring the input memory
address region is actually mapped to the physical memory.

However, if the end address is just aligned with the top of memory,
the condition check treats the address is over the top of memory, and
write-back attribute is not returned.

And this hits in a real use case with NVDIMM: the nd_pmem module tries
to map NVDIMMs as cacheable memories when NVDIMMs are connected. If a
NVDIMM is the last of the DIMMs, the performance of this NVDIMM becomes
very low since it is aligned with the top of memory and its memory type
is uncached-minus.

Move the input end address change to inclusive up into
mtrr_type_lookup(), before checking for the top of memory in either
mtrr_type_lookup_{variable,fixed}() helpers.

 [ bp: Massage commit message. ]

Fixes: 0cc705f56e40 ("x86/mm/mtrr: Clean up mtrr_type_lookup()")
Signed-off-by: Ying-Tsun Huang <ying-tsun.huang@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20201215070721.4349-1-ying-tsun.huang@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/mtrr/generic.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -166,9 +166,6 @@ static u8 mtrr_type_lookup_variable(u64
 	*repeat = 0;
 	*uniform = 1;
 
-	/* Make end inclusive instead of exclusive */
-	end--;
-
 	prev_match = MTRR_TYPE_INVALID;
 	for (i = 0; i < num_var_ranges; ++i) {
 		unsigned short start_state, end_state, inclusive;
@@ -260,6 +257,9 @@ u8 mtrr_type_lookup(u64 start, u64 end,
 	int repeat;
 	u64 partial_end;
 
+	/* Make end inclusive instead of exclusive */
+	end--;
+
 	if (!mtrr_state_set)
 		return MTRR_TYPE_INVALID;
 


