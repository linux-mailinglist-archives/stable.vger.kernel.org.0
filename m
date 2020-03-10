Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E43C217FC58
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729816AbgCJNUX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:20:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730951AbgCJNHT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:07:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C68620409;
        Tue, 10 Mar 2020 13:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845638;
        bh=rMQn7kjsa7T0S3IBhZrsTg2HDBVaXevtNP7v9XkF4Dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e20auHCVYrL6VsKvlvwHe75hIYKfpXsbj2Sq6mzUoSKgdfJrvmMOvRmGEBNsXcttS
         q0CXG5oDedBCh+PtQWI58iNmyFtMbooLq/eiDtTNW6YKH4Ctrucih2YcTVmsYpxqoo
         KgPvwlZmzFc/nh1fdfnrCkscQoEc8HpuK9tkL4W8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Paul Burton <paulburton@kernel.org>, ralf@linux-mips.org,
        linux-mips@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 4.14 045/126] MIPS: VPE: Fix a double free and a memory leak in release_vpe()
Date:   Tue, 10 Mar 2020 13:41:06 +0100
Message-Id: <20200310124207.176316001@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
References: <20200310124203.704193207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit bef8e2dfceed6daeb6ca3e8d33f9c9d43b926580 upstream.

Pointer on the memory allocated by 'alloc_progmem()' is stored in
'v->load_addr'. So this is this memory that should be freed by
'release_progmem()'.

'release_progmem()' is only a call to 'kfree()'.

With the current code, there is both a double free and a memory leak.
Fix it by passing the correct pointer to 'release_progmem()'.

Fixes: e01402b115ccc ("More AP / SP bits for the 34K, the Malta bits and things. Still wants")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Paul Burton <paulburton@kernel.org>
Cc: ralf@linux-mips.org
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/kernel/vpe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/kernel/vpe.c
+++ b/arch/mips/kernel/vpe.c
@@ -134,7 +134,7 @@ void release_vpe(struct vpe *v)
 {
 	list_del(&v->list);
 	if (v->load_addr)
-		release_progmem(v);
+		release_progmem(v->load_addr);
 	kfree(v);
 }
 


