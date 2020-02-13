Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57C8015C183
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728535AbgBMPXz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:23:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:35940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728238AbgBMPXy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:23:54 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AE4E24690;
        Thu, 13 Feb 2020 15:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607433;
        bh=p8cD7wYDh+Z1T66YAJXu20TxPoEcVP8J4XSrr6VskDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xocKHBl7wi+bCsF7i39IxCxlJKECJl6JRwAdwPt0PQXoTkaIhNPdtQRjidn25Yws3
         ng/MdqDekEAkv9uBozmtZNBZwaVO/nZPH4KEw6Ot2Epjxp6vG5CPAL+vKBMSoVUstj
         9h4aV5MYlNXSMOSGsOZrXn/pkKoSKzrO3krFgAvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 4.9 068/116] nfsd: fix delay timer on 32-bit architectures
Date:   Thu, 13 Feb 2020 07:20:12 -0800
Message-Id: <20200213151909.332090680@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151842.259660170@linuxfoundation.org>
References: <20200213151842.259660170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 2561c92b12f4f4e386d453556685f75775c0938b upstream.

The nfsd4_cb_layout_done() function takes a 'time_t' value,
multiplied by NSEC_PER_SEC*2 to get a nanosecond value.

This works fine on 64-bit architectures, but on 32-bit, any
value over 1 second results in a signed integer overflow
with unexpected results.

Cast one input to a 64-bit type in order to produce the
same result that we have on 64-bit architectures, regarless
of the type of nfsd4_lease.

Fixes: 6b9b21073d3b ("nfsd: give up on CB_LAYOUTRECALLs after two lease periods")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4layouts.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4layouts.c
+++ b/fs/nfsd/nfs4layouts.c
@@ -680,7 +680,7 @@ nfsd4_cb_layout_done(struct nfsd4_callba
 
 		/* Client gets 2 lease periods to return it */
 		cutoff = ktime_add_ns(task->tk_start,
-					 nn->nfsd4_lease * NSEC_PER_SEC * 2);
+					 (u64)nn->nfsd4_lease * NSEC_PER_SEC * 2);
 
 		if (ktime_before(now, cutoff)) {
 			rpc_delay(task, HZ/100); /* 10 mili-seconds */


