Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 802FCB369D
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 10:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730576AbfIPIuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 04:50:18 -0400
Received: from mga18.intel.com ([134.134.136.126]:19905 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728142AbfIPIuS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Sep 2019 04:50:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Sep 2019 01:50:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,512,1559545200"; 
   d="scan'208";a="193381785"
Received: from unknown (HELO localhost) ([10.252.55.169])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Sep 2019 01:50:13 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-integrity@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Mimi Zohar <zohar@linux.ibm.com>, stable@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] tpm: Wrap the buffer from the caller to tpm_buf in tpm_send()
Date:   Mon, 16 Sep 2019 11:50:08 +0300
Message-Id: <20190916085008.22239-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

tpm_send() does not give anymore the result back to the caller. This
would require another memcpy(), which kind of tells that the whole
approach is somewhat broken. Instead, as Mimi suggested, this commit
just wraps the data to the tpm_buf, and thus the result will not go to
the garbage.

Obviously this assumes from the caller that it passes large enough
buffer, which makes the whole API somewhat broken because it could be
different size than @buflen but since trusted keys is the only module
using this API right now I think that this fix is sufficient for the
moment.

In the near future the plan is to replace the parameters with a tpm_buf
created by the caller.

Reported-by: Mimi Zohar <zohar@linux.ibm.com>
Suggested-by: Mimi Zohar <zohar@linux.ibm.com>
Cc: stable@vger.kernel.org
Fixes: 412eb585587a ("use tpm_buf in tpm_transmit_cmd() as the IO parameter")
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm-interface.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index d9ace5480665..2459d36dd8cc 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -358,13 +358,9 @@ int tpm_send(struct tpm_chip *chip, void *cmd, size_t buflen)
 	if (!chip)
 		return -ENODEV;
 
-	rc = tpm_buf_init(&buf, 0, 0);
-	if (rc)
-		goto out;
-
-	memcpy(buf.data, cmd, buflen);
+	buf.data = cmd;
 	rc = tpm_transmit_cmd(chip, &buf, 0, "attempting to a send a command");
-	tpm_buf_destroy(&buf);
+
 out:
 	tpm_put_ops(chip);
 	return rc;
-- 
2.20.1

