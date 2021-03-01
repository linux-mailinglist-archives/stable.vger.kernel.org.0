Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C9D3285A5
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236348AbhCAQ4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:56:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:50620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235778AbhCAQtp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:49:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C31064FAC;
        Mon,  1 Mar 2021 16:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616380;
        bh=VF+Va3FNcGJGaC76HLPyhSnsPpyHlqCgzlCKJHXrNdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kP33edt8L5xyiiftUTelGudSMd1b9e3W+H3/kBG/6oOWq4rETrQKOAf2PqGhpBrSU
         LGy0K8s7nnNx1Suz2DKDW5RpqbYOd6LGJAP11u4IWKdhUL0uudnol2KBhO3lu4ZBQy
         g4EKE/R7vXzitlVgQyoo/2AFhOYd0lCkGx8D63mU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 101/176] Input: elo - fix an error code in elo_connect()
Date:   Mon,  1 Mar 2021 17:12:54 +0100
Message-Id: <20210301161025.994598132@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 0958351e93fa0ac142f6dd8bd844441594f30a57 ]

If elo_setup_10() fails then this should return an error code instead
of success.

Fixes: fae3006e4b42 ("Input: elo - add support for non-pressure-sensitive touchscreens")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/YBKFd5CvDu+jVmfW@mwanda
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/elo.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/elo.c b/drivers/input/touchscreen/elo.c
index 83433e8efff70..9642b0dd24f9b 100644
--- a/drivers/input/touchscreen/elo.c
+++ b/drivers/input/touchscreen/elo.c
@@ -345,8 +345,10 @@ static int elo_connect(struct serio *serio, struct serio_driver *drv)
 	switch (elo->id) {
 
 	case 0: /* 10-byte protocol */
-		if (elo_setup_10(elo))
+		if (elo_setup_10(elo)) {
+			err = -EIO;
 			goto fail3;
+		}
 
 		break;
 
-- 
2.27.0



