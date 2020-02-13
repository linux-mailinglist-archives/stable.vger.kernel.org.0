Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E68F615C1B1
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729034AbgBMPZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:25:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:41506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387456AbgBMPZe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:25:34 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28C6124690;
        Thu, 13 Feb 2020 15:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607533;
        bh=4/tTk0ZiW7DQJxVy89AldRXoFxuJGR2zrHVnfhe/Pt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=izDlQsaw1tv28HURyV2qmR4Js+sQ8TfNF6xGL3Em8JL38bX9RYIh+n7nU4YJPGt7j
         xWP+r1wXU+wxy98BgrZvvezktp3581N8TKVVtnS9Mjuz+LsMLMPsR51x4EJvLQnyBc
         ZU8fFk78cGMdzMLs3LP+XaxudNq5kJ6+kv25Zmv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 4.14 106/173] nfsd: fix delay timer on 32-bit architectures
Date:   Thu, 13 Feb 2020 07:20:09 -0800
Message-Id: <20200213151959.417339917@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
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
@@ -683,7 +683,7 @@ nfsd4_cb_layout_done(struct nfsd4_callba
 
 		/* Client gets 2 lease periods to return it */
 		cutoff = ktime_add_ns(task->tk_start,
-					 nn->nfsd4_lease * NSEC_PER_SEC * 2);
+					 (u64)nn->nfsd4_lease * NSEC_PER_SEC * 2);
 
 		if (ktime_before(now, cutoff)) {
 			rpc_delay(task, HZ/100); /* 10 mili-seconds */


