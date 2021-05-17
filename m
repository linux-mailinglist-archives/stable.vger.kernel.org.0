Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF1BE38336E
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240735AbhEQO6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:58:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240830AbhEQOz6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:55:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD7BF61996;
        Mon, 17 May 2021 14:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261510;
        bh=VUshgsG/2RrNZ38dN1n3YOr6lctXxWIjlFzdCAnZNaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AVEQvCsbGj/MEjuuf9CqIZ9cGg/81JjyXX2PuLDuM02G9ClDPrsLTPGKvH6QQCGee
         gazfVm0x40RE8XaFeRVfbIfonZEoaAJ1E9TDENzNOvbdg3dEYJMUoPnqiSMaxfuO0G
         xRqEEhufRmPOvlqm8hIJ92+YJNF+cFO++ua8MFHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 118/329] remoteproc: qcom_q6v5_mss: Validate p_filesz in ELF loader
Date:   Mon, 17 May 2021 16:00:29 +0200
Message-Id: <20210517140306.097026674@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit 3d2ee78906af5f08d499d6aa3aa504406fa38106 ]

Analog to the issue in the common mdt_loader code the MSS ELF loader
does not validate that p_filesz bytes will fit in the memory region and
that the loaded segments are not truncated. Fix this in the same way
as proposed for the mdt_loader.

Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Fixes: 135b9e8d1cd8 ("remoteproc: qcom_q6v5_mss: Validate modem blob firmware size before load")
Link: https://lore.kernel.org/r/20210312232002.3466791-1-bjorn.andersson@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_mss.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
index 66106ba25ba3..14e0ce5f18f5 100644
--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -1210,6 +1210,14 @@ static int q6v5_mpss_load(struct q6v5 *qproc)
 			goto release_firmware;
 		}
 
+		if (phdr->p_filesz > phdr->p_memsz) {
+			dev_err(qproc->dev,
+				"refusing to load segment %d with p_filesz > p_memsz\n",
+				i);
+			ret = -EINVAL;
+			goto release_firmware;
+		}
+
 		ptr = memremap(qproc->mpss_phys + offset, phdr->p_memsz, MEMREMAP_WC);
 		if (!ptr) {
 			dev_err(qproc->dev,
@@ -1241,6 +1249,16 @@ static int q6v5_mpss_load(struct q6v5 *qproc)
 				goto release_firmware;
 			}
 
+			if (seg_fw->size != phdr->p_filesz) {
+				dev_err(qproc->dev,
+					"failed to load segment %d from truncated file %s\n",
+					i, fw_name);
+				ret = -EINVAL;
+				release_firmware(seg_fw);
+				memunmap(ptr);
+				goto release_firmware;
+			}
+
 			release_firmware(seg_fw);
 		}
 
-- 
2.30.2



