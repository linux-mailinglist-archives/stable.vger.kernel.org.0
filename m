Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E556463776
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242541AbhK3Oxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:53:53 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:56988 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242526AbhK3Owj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:52:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 82D59CE1A57;
        Tue, 30 Nov 2021 14:49:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC208C53FD3;
        Tue, 30 Nov 2021 14:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283757;
        bh=3xYbkZoidA/SdAusJW58QQS+flHpRnGXxkykZr45L/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hHLIkpgDpbuCtmAfYqY+aJw2qvSEFto0IZY/Mon9MWpn7MR8HxgzeXPlkwdx7F1lw
         6FVG+XEFodUL46L0hPX4IbXI5O8vRg8mSS7OJ1qQGIWySh8XKIw9XDdXFgMiuijcFA
         5ujEam71zNV4ZLLsdRMhueRbr7ZEbOBYd3pEwg0uG48AAY9LhHsZ3n1WERQQPsh1gD
         jIUoq7i1WNbYQ3NhfoVbJpwiW2dOUMc1kIX9NkL9sBRiDM7kmxdKIQM/iqzChoVCqV
         izot/lqCXrgDzDff9Ql9/TkBCFQ2WUTKAWR8MqOinu5ESEhU+V02ZmO3MOKo61Xzbl
         fGJM2N153djKg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>, perex@perex.cz,
        tiwai@suse.com, xen-devel@lists.xenproject.org,
        alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.15 52/68] xen: flag xen_snd_front to be not essential for system boot
Date:   Tue, 30 Nov 2021 09:46:48 -0500
Message-Id: <20211130144707.944580-52-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

[ Upstream commit de6da33e6cb79abd4a5721b65b9a7dbed24378f8 ]

The Xen pv sound driver is not essential for booting. Set the respective
flag.

[boris: replace semicolon with comma]

Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: https://lore.kernel.org/r/20211022064800.14978-6-jgross@suse.com
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/xen/xen_snd_front.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/xen/xen_snd_front.c b/sound/xen/xen_snd_front.c
index 2cb0a19be2b85..4041748c12e51 100644
--- a/sound/xen/xen_snd_front.c
+++ b/sound/xen/xen_snd_front.c
@@ -358,6 +358,7 @@ static struct xenbus_driver xen_driver = {
 	.probe = xen_drv_probe,
 	.remove = xen_drv_remove,
 	.otherend_changed = sndback_changed,
+	.not_essential = true,
 };
 
 static int __init xen_drv_init(void)
-- 
2.33.0

