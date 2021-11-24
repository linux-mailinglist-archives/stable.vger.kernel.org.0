Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEAB45C5EE
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351729AbhKXOCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:02:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:47006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353623AbhKXOAg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:00:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1375C632DF;
        Wed, 24 Nov 2021 13:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759354;
        bh=4XE6KWei2eAG36JH0UcyF2SjwoKshUapFqcxs2AaOWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=exWTDgwK0IqIj64Jtao63jMwvQQ7vhgFqFzjyqrfPjNFFGAVyVmiTY2+EL0JVCi8R
         Pev+zdA/gb4FMAiWfDfiYXMDYowSr7dBOk5UPeCvCuXKsZ1n1TcLZfIOZVMRU5rz8J
         CLt5jHhwHOBUnsjRB3KWPTxZrTPej+uEy1G2QXiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Matthew Perkowski <mgperkow@gmail.com>, stable@kernel.org
Subject: [PATCH 5.15 213/279] ata: libata: improve ata_read_log_page() error message
Date:   Wed, 24 Nov 2021 12:58:20 +0100
Message-Id: <20211124115726.103396986@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

commit 23ef63d5e14f916c5bba39128ebef395859d7c0f upstream.

If ata_read_log_page() fails to read a log page, the ata_dev_err() error
message only print the page number, omitting the log number. In case of
error, facilitate debugging by also printing the log number.

Cc: stable@kernel.org # 5.15
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Tested-by: Matthew Perkowski <mgperkow@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2031,8 +2031,9 @@ retry:
 			dev->horkage |= ATA_HORKAGE_NO_DMA_LOG;
 			goto retry;
 		}
-		ata_dev_err(dev, "Read log page 0x%02x failed, Emask 0x%x\n",
-			    (unsigned int)page, err_mask);
+		ata_dev_err(dev,
+			    "Read log 0x%02x page 0x%02x failed, Emask 0x%x\n",
+			    (unsigned int)log, (unsigned int)page, err_mask);
 	}
 
 	return err_mask;


