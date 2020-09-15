Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6251626B6BB
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgIPAKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:10:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726946AbgIOO0u (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:26:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1A732246B;
        Tue, 15 Sep 2020 14:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179590;
        bh=ugCFKD2zX5RIupkCCF9zzW/uoiRqME3jUwCIcPGmbFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OsZ+fNpaXJ8PAA52UaNyaq+AhCuNLG5ZG2pg58espTFW9KsZVGRpzLJIqLmA+NV52
         RLvH8tLZ8lTKmvCtMz5hKaq4IKBFy8upDA3lqles2M5tIV92dLEO87pT4xn2WpjTYo
         KZEIu+MSuUSJ/cTBiLlvgtOvdZPfSiHBWypSuojs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 041/132] firestream: Fix memleak in fs_open
Date:   Tue, 15 Sep 2020 16:12:23 +0200
Message-Id: <20200915140646.176822601@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 15ac5cdafb9202424206dc5bd376437a358963f9 ]

When make_rate() fails, vcc should be freed just
like other error paths in fs_open().

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/atm/firestream.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/atm/firestream.c b/drivers/atm/firestream.c
index d287837ed7555..5acb459856752 100644
--- a/drivers/atm/firestream.c
+++ b/drivers/atm/firestream.c
@@ -998,6 +998,7 @@ static int fs_open(struct atm_vcc *atm_vcc)
 				error = make_rate (pcr, r, &tmc0, NULL);
 				if (error) {
 					kfree(tc);
+					kfree(vcc);
 					return error;
 				}
 			}
-- 
2.25.1



