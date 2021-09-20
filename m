Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04CAD411D3E
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347072AbhITRRf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:17:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:42492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345746AbhITRPf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:15:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2088161A07;
        Mon, 20 Sep 2021 16:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157122;
        bh=uuZMw6J5hMtC9lRbJ1wg88tUyZpGYzYRmpNXWwfNY5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nsxwt2TeoLhdPpe/ZsNrkJ4Kde72hgzHpZTkxyggHT3AngJFMP+dtDkoKdrIaLlKm
         s45NEp7cqNU0O8fnuth863Z1z9EoWlCrxU/bOvKxE/at30hZ07cJNVMof4SWiVPB7U
         JdsdDcwLaKjuoA634s/nsPSzdOlmxVGUlSpNxykc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 063/217] Bluetooth: increase BTNAMSIZ to 21 chars to fix potential buffer overflow
Date:   Mon, 20 Sep 2021 18:41:24 +0200
Message-Id: <20210920163926.761883757@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 713baf3dae8f45dc8ada4ed2f5fdcbf94a5c274d ]

An earlier commit replaced using batostr to using %pMR sprintf for the
construction of session->name. Static analysis detected that this new
method can use a total of 21 characters (including the trailing '\0')
so we need to increase the BTNAMSIZ from 18 to 21 to fix potential
buffer overflows.

Addresses-Coverity: ("Out-of-bounds write")
Fixes: fcb73338ed53 ("Bluetooth: Use %pMR in sprintf/seq_printf instead of batostr")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/cmtp/cmtp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/cmtp/cmtp.h b/net/bluetooth/cmtp/cmtp.h
index c32638dddbf9..f6b9dc4e408f 100644
--- a/net/bluetooth/cmtp/cmtp.h
+++ b/net/bluetooth/cmtp/cmtp.h
@@ -26,7 +26,7 @@
 #include <linux/types.h>
 #include <net/bluetooth/bluetooth.h>
 
-#define BTNAMSIZ 18
+#define BTNAMSIZ 21
 
 /* CMTP ioctl defines */
 #define CMTPCONNADD	_IOW('C', 200, int)
-- 
2.30.2



