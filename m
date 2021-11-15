Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A25451416
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348964AbhKOUBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:01:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:45398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344214AbhKOTYH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 105E463304;
        Mon, 15 Nov 2021 18:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002434;
        bh=hlGbKeLsFMgu4kZULXb05vWKOyHRKchfgTxVIiG2lPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=abjlTk5MOsObpZqxTJt0iVeaQTaU6zE4QUYJh3YaCYXL9xesUeya68329U8LxrQ7P
         NmqdoUXRo4x5TkBYWFwF/8n50J5ywBb7GkEYn/N0tySImB84npCD2gMneyPL+aYk4q
         rPyPBWkzC7Ej9eaW9UXLl+ylYElLZqO4eLZHpT3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 566/917] staging: r8188eu: fix memory leak in rtw_set_key
Date:   Mon, 15 Nov 2021 18:01:01 +0100
Message-Id: <20211115165447.982406745@linuxfoundation.org>
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

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 393db0f6827f96054a769ba3a38aa382d137d3c7 ]

Before returning with an error we should free allocated buffers, since
they are not assigned to anywhere.

Fixes: 15865124feed ("staging: r8188eu: introduce new core dir for RTL8188eu driver")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Link: https://lore.kernel.org/r/ee783fbb71abb549505b84542223be7a7c905eea.1630692375.git.paskripkin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/r8188eu/core/rtw_mlme.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/r8188eu/core/rtw_mlme.c b/drivers/staging/r8188eu/core/rtw_mlme.c
index 1115ff5d865ad..bd991d7ed8090 100644
--- a/drivers/staging/r8188eu/core/rtw_mlme.c
+++ b/drivers/staging/r8188eu/core/rtw_mlme.c
@@ -1722,6 +1722,8 @@ int rtw_set_key(struct adapter *adapter, struct security_priv *psecuritypriv, in
 		psetkeyparm->grpkey = 1;
 		break;
 	default:
+		kfree(psetkeyparm);
+		kfree(pcmd);
 		res = _FAIL;
 		goto exit;
 	}
-- 
2.33.0



