Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697F64988B8
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241904AbiAXSuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:50:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49496 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235976AbiAXStX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:49:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63733B8121D;
        Mon, 24 Jan 2022 18:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E366C340E5;
        Mon, 24 Jan 2022 18:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050161;
        bh=rH7vXnLsMeqrHjpj2FZxMKF7MTGw1pwYc0KA4eDVaSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v/S5oguqmVQ5gVKB1idw5OxB4KNeCoi58U3FiilpdqcJv0Y/IlHGA0HPduhAeXDx4
         CVWw5C9HQ7wGkAQwwjmj7rRvw1w9E3SZ2aP9vkoTLHcpU+gy3Yvkcwmr6VBi3xnz5o
         CnOnw2Y3wof4o7ecGrs8Nhjirz8Wy7is1PMKXoBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhou Qingyang <zhou1615@umn.edu>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 030/114] media: dib8000: Fix a memleak in dib8000_init()
Date:   Mon, 24 Jan 2022 19:42:05 +0100
Message-Id: <20220124183928.048787958@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
References: <20220124183927.095545464@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhou Qingyang <zhou1615@umn.edu>

[ Upstream commit 8dbdcc7269a83305ee9d677b75064d3530a48ee2 ]

In dib8000_init(), the variable fe is not freed or passed out on the
failure of dib8000_identify(&state->i2c), which could lead to a memleak.

Fix this bug by adding a kfree of fe in the error path.

This bug was found by a static analyzer. The analysis employs
differential checking to identify inconsistent security operations
(e.g., checks or kfrees) between two code paths and confirms that the
inconsistent operations are not recovered in the current function or
the callers, so they constitute bugs.

Note that, as a bug found by static analysis, it can be a false
positive or hard to trigger. Multiple researchers have cross-reviewed
the bug.

Builds with CONFIG_DVB_DIB8000=m show no new warnings,
and our static analyzer no longer warns about this code.

Fixes: 77e2c0f5d471 ("V4L/DVB (12900): DiB8000: added support for DiBcom ISDB-T/ISDB-Tsb demodulator DiB8000")
Signed-off-by: Zhou Qingyang <zhou1615@umn.edu>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/dib8000.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 94c26270fff0e..b8af5a3c707f8 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -4461,8 +4461,10 @@ static struct dvb_frontend *dib8000_init(struct i2c_adapter *i2c_adap, u8 i2c_ad
 
 	state->timf_default = cfg->pll->timf;
 
-	if (dib8000_identify(&state->i2c) == 0)
+	if (dib8000_identify(&state->i2c) == 0) {
+		kfree(fe);
 		goto error;
+	}
 
 	dibx000_init_i2c_master(&state->i2c_master, DIB8000, state->i2c.adap, state->i2c.addr);
 
-- 
2.34.1



