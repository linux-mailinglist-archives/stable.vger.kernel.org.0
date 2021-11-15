Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367F8451305
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244808AbhKOToY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:44:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:44624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245286AbhKOTT6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:19:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B15EE6352D;
        Mon, 15 Nov 2021 18:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001111;
        bh=WWaQGgmjyPlNANn38lv8ha4hD3vCPfBuI2DDBxHsM0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q/io9kZwquDi6dCglHzwYqlqQjUxAVZTGgIXqGppFcz66Jd5D7VhbOYYBkb3hHer8
         ScmySZcJNgWDU+xnVO4KObN/O0m6Qux/tixEzDIacUqgNfoZrThZu0AGs1KKo6okqz
         w/3MNapPVjd1PrvGrGRJYxjMXGNrCcaD1xy3+YaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5.15 066/917] powerpc/kvm: Fix kvm_use_magic_page
Date:   Mon, 15 Nov 2021 17:52:41 +0100
Message-Id: <20211115165431.008479763@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 0c8eb2884a42d992c7726539328b7d3568f22143 upstream.

When switching from __get_user to fault_in_pages_readable, commit
9f9eae5ce717 broke kvm_use_magic_page: like __get_user,
fault_in_pages_readable returns 0 on success.

Fixes: 9f9eae5ce717 ("powerpc/kvm: Prefer fault_in_pages_readable function")
Cc: stable@vger.kernel.org # v4.18+
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/kvm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/kvm.c
+++ b/arch/powerpc/kernel/kvm.c
@@ -669,7 +669,7 @@ static void __init kvm_use_magic_page(vo
 	on_each_cpu(kvm_map_magic_page, &features, 1);
 
 	/* Quick self-test to see if the mapping works */
-	if (!fault_in_pages_readable((const char *)KVM_MAGIC_PAGE, sizeof(u32))) {
+	if (fault_in_pages_readable((const char *)KVM_MAGIC_PAGE, sizeof(u32))) {
 		kvm_patching_worked = false;
 		return;
 	}


