Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781A73CDEE5
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344736AbhGSPGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:06:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:32996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345484AbhGSPEd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:04:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBBBD61364;
        Mon, 19 Jul 2021 15:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709442;
        bh=ppW35qgSusQj6wBIpMSCIYMQAiPVAwVu0i48L2F97tA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IJ8zFoVSfsUlxNSwl5SyJ1ap0Xy6aGHfCQQmxtDj4GczwoeScUZlx1lD1xJqVIYqw
         6/W0tbT1mn1oIYYVKEPJSQzTTt3cW7PaTsVeDM2bbdxA3xF/Y7QaGRDMQKmOVJiz9k
         zBbuIVwsb8DTmNhN1BXZVP0PQ12pcmS59gLNCWJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        anton.ivanov@cambridgegreys.com,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 385/421] um: fix error return code in slip_open()
Date:   Mon, 19 Jul 2021 16:53:16 +0200
Message-Id: <20210719144959.729982081@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit b77e81fbe5f5fb4ad9a61ec80f6d1e30b6da093a ]

Fix to return a negative error code from the error handling case instead
of 0, as done elsewhere in this function.

Fixes: a3c77c67a443 ("[PATCH] uml: slirp and slip driver cleanups and fixes")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Acked-By: anton.ivanov@cambridgegreys.com
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/slip_user.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/um/drivers/slip_user.c b/arch/um/drivers/slip_user.c
index 0d6b66c64a81..76d155631c5d 100644
--- a/arch/um/drivers/slip_user.c
+++ b/arch/um/drivers/slip_user.c
@@ -145,7 +145,8 @@ static int slip_open(void *data)
 	}
 	sfd = err;
 
-	if (set_up_tty(sfd))
+	err = set_up_tty(sfd);
+	if (err)
 		goto out_close2;
 
 	pri->slave = sfd;
-- 
2.30.2



