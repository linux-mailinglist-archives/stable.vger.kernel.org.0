Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50033163269
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbgBRT6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 14:58:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:36610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727906AbgBRT6p (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 14:58:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A697D24125;
        Tue, 18 Feb 2020 19:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582055925;
        bh=VlYFbi8R93NZ9MLjbFG8aNwqFw6eH/NfQOSq89lK47Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p6SGSzlpgKfY/jGyPrOwXRrMLNgI8WfnIQjdj2w0rePmUxUZL9L8bof2yUJco4OFA
         WibSeljLZK7UhI0S2VZ81ohep/G2jsrIYiwQrKb2iQGOifT/01rGeJT+D1pSM564rl
         QZnNfLF8tXqcDhsqsqCXT6HdYAOSOo7mtWRnoq3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.4 33/66] s390/uv: Fix handling of length extensions
Date:   Tue, 18 Feb 2020 20:55:00 +0100
Message-Id: <20200218190431.133878860@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190428.035153861@linuxfoundation.org>
References: <20200218190428.035153861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

commit 27dc0700c3be7c681cea03c5230b93d02f623492 upstream.

The query parameter block might contain additional information and can
be extended in the future. If the size of the block does not suffice we
get an error code of rc=0x100.  The buffer will contain all information
up to the specified size and the hypervisor/guest simply do not need the
additional information as they do not know about the new data.  That
means that we can (and must) accept rc=0x100 as success.

Cc: stable@vger.kernel.org
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Fixes: 5abb9351dfd9 ("s390/uv: introduce guest side ultravisor code")
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/boot/uv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/s390/boot/uv.c
+++ b/arch/s390/boot/uv.c
@@ -15,7 +15,8 @@ void uv_query_info(void)
 	if (!test_facility(158))
 		return;
 
-	if (uv_call(0, (uint64_t)&uvcb))
+	/* rc==0x100 means that there is additional data we do not process */
+	if (uv_call(0, (uint64_t)&uvcb) && uvcb.header.rc != 0x100)
 		return;
 
 	if (test_bit_inv(BIT_UVC_CMD_SET_SHARED_ACCESS, (unsigned long *)uvcb.inst_calls_list) &&


