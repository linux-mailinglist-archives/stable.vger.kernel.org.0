Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 127D0498ACE
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344183AbiAXTHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:07:01 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60716 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345923AbiAXTEs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:04:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66598B8121C;
        Mon, 24 Jan 2022 19:04:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB06C340E5;
        Mon, 24 Jan 2022 19:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051085;
        bh=aV3zafJQPEzD6m4LFBk4Gt1VO07mpJBE5/dHt1hesZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gafh2o6tbFEQc+u0vdORX755OSrDrrcBYPekSJnmEXCHOscwsdINLLxe24JefxQvA
         lsDD4MSMn59aPxNoXbq8Xu7VvRPPwfBM3mZ7Z3ZdJP/099u6j8sYUquO5Pr1kvCTJ3
         NXTn3wQBFMHC82oybi/BoTXAee5rMvBrf2tT6G6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhou Qingyang <zhou1615@umn.edu>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 050/186] media: dib8000: Fix a memleak in dib8000_init()
Date:   Mon, 24 Jan 2022 19:42:05 +0100
Message-Id: <20220124183938.738872060@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
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
index 59ab01dc62b19..c429392ebbe63 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -4476,8 +4476,10 @@ static struct dvb_frontend *dib8000_init(struct i2c_adapter *i2c_adap, u8 i2c_ad
 
 	state->timf_default = cfg->pll->timf;
 
-	if (dib8000_identify(&state->i2c) == 0)
+	if (dib8000_identify(&state->i2c) == 0) {
+		kfree(fe);
 		goto error;
+	}
 
 	dibx000_init_i2c_master(&state->i2c_master, DIB8000, state->i2c.adap, state->i2c.addr);
 
-- 
2.34.1



