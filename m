Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C19CEB35B1
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 09:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbfIPHfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 03:35:48 -0400
Received: from mga06.intel.com ([134.134.136.31]:44723 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfIPHfs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Sep 2019 03:35:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Sep 2019 00:35:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,510,1559545200"; 
   d="scan'208";a="211068979"
Received: from sshkruni-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.38.138])
  by fmsmga004.fm.intel.com with ESMTP; 16 Sep 2019 00:35:42 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-integrity@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Mimi Zohar <zohar@linux.ibm.com>, stable@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] tpm: Fix tpm_send() length calculation
Date:   Mon, 16 Sep 2019 10:35:35 +0300
Message-Id: <20190916073535.25117-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Set the size of the tpm_buf correctly. Now it is set to the header
length by tpm_buf_init().

Reported-by: Mimi Zohar <zohar@linux.ibm.com>
Cc: stable@vger.kernel.org
Fixes: 412eb585587a ("use tpm_buf in tpm_transmit_cmd() as the IO parameter")
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm-interface.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index d9ace5480665..4aa7e7f91139 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -363,6 +363,8 @@ int tpm_send(struct tpm_chip *chip, void *cmd, size_t buflen)
 		goto out;
 
 	memcpy(buf.data, cmd, buflen);
+	buf.length = buflen;
+
 	rc = tpm_transmit_cmd(chip, &buf, 0, "attempting to a send a command");
 	tpm_buf_destroy(&buf);
 out:
-- 
2.20.1

