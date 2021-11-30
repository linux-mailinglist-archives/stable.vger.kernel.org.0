Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D164637F6
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243373AbhK3O5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:57:10 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48972 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243389AbhK3OzG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:55:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6938EB81A4C;
        Tue, 30 Nov 2021 14:51:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0B8C53FC7;
        Tue, 30 Nov 2021 14:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283905;
        bh=HnNEGH4yNQGvklDjY2eQMfGoP//aAe4wVVZXymkNzJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aziqfQYupOUJR7kxEdK9QqSLKI2Ml6H9oB2B7Lee33PhVOSVDXRZiJ/9TSYlvsgf0
         xYaO1+k6xdO/yBBS/7AFihN/ZMplv9pAcZDeB5Knfade2xOaHVxvIdfcUuotV2p3Hy
         bsRntE7qmo7duutHxnHPpJZ+iOz86+s/YTX23WA3KYHNyJhIWLb5clZFqa1ENxaNj3
         ntg8pwlo6YRyR+5PdGfzqJwk8ODzUlQU+5jElPijDSA7XT/N6szuql/z8GEjiGK4Ix
         QNcHDoo5PfEHpFTTEuVU2D4MZNb0hv2HbhT1W5SsfmRLaSuOfO9j9wb0Y6OQp2gOhZ
         7wQvzE3zth6CQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org,
        jirislaby@kernel.org, jbeulich@suse.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.10 36/43] xen: flag hvc_xen to be not essential for system boot
Date:   Tue, 30 Nov 2021 09:50:13 -0500
Message-Id: <20211130145022.945517-36-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145022.945517-1-sashal@kernel.org>
References: <20211130145022.945517-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 0239143490a9fa1344955dde93527b09f5576dac ]

The Xen pv console driver is not essential for boot. Set the respective
flag.

Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: https://lore.kernel.org/r/20211022064800.14978-4-jgross@suse.com
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/hvc/hvc_xen.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
index 92c9a476defc9..55a435e329470 100644
--- a/drivers/tty/hvc/hvc_xen.c
+++ b/drivers/tty/hvc/hvc_xen.c
@@ -511,6 +511,7 @@ static struct xenbus_driver xencons_driver = {
 	.remove = xencons_remove,
 	.resume = xencons_resume,
 	.otherend_changed = xencons_backend_changed,
+	.not_essential = true,
 };
 #endif /* CONFIG_HVC_XEN_FRONTEND */
 
-- 
2.33.0

