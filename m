Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30353289F6
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234291AbhCASJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:09:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:55008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239079AbhCASC6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:02:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2A5964FD6;
        Mon,  1 Mar 2021 17:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620644;
        bh=I81eUAK/w58NeLuYC4wJgq6NUF9JLGlGgxtPg8P5f2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qc5pXscBU5TKC+Pcm47IK6XHzW1DcZpTmCDsE88vWAey/G3cLJNhItTUk8EFPFZJw
         sztdTPgYh9Htj3eL2uV5DQOfa0yqHoLuAU7lizT9ye70g43agaKWMTyoKi48WzuIDu
         sZpv0eeZ/i53hrG+3pZOk5vSZGubrCi3s3AaOGpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Luo Meng <luomeng12@huawei.com>,
        Akihiro Tsukada <tskd08@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 227/775] media: qm1d1c0042: fix error return code in qm1d1c0042_init()
Date:   Mon,  1 Mar 2021 17:06:35 +0100
Message-Id: <20210301161212.845199355@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luo Meng <luomeng12@huawei.com>

[ Upstream commit fcf8d018bdca0453b8d6359062e6bc1512d04c38 ]

Fix to return a negative error code from the error handling case
instead of 0 in function qm1d1c0042_init(), as done elsewhere
in this function.

Fixes: ab4d14528fdf ("[media] em28xx: add support for PLEX PX-BCUD (ISDB-S)")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Luo Meng <luomeng12@huawei.com>
Acked-by: Akihiro Tsukada <tskd08@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/tuners/qm1d1c0042.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/tuners/qm1d1c0042.c b/drivers/media/tuners/qm1d1c0042.c
index 0e26d22f0b268..53aa2558f71e1 100644
--- a/drivers/media/tuners/qm1d1c0042.c
+++ b/drivers/media/tuners/qm1d1c0042.c
@@ -343,8 +343,10 @@ static int qm1d1c0042_init(struct dvb_frontend *fe)
 		if (val == reg_initval[reg_index][0x00])
 			break;
 	}
-	if (reg_index >= QM1D1C0042_NUM_REG_ROWS)
+	if (reg_index >= QM1D1C0042_NUM_REG_ROWS) {
+		ret = -EINVAL;
 		goto failed;
+	}
 	memcpy(state->regs, reg_initval[reg_index], QM1D1C0042_NUM_REGS);
 	usleep_range(2000, 3000);
 
-- 
2.27.0



