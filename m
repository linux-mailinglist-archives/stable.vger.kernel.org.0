Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E75E6AEC7A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbjCGRzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:55:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232357AbjCGRy5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:54:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80C439CBFA
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:49:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2F4861507
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED63C433D2;
        Tue,  7 Mar 2023 17:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211392;
        bh=ix4XA8LgIeBUpIBPMcFU6UVI/cKS8WZK4a9MKCdJvEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nLTsgkCrJqgEZ3bSdQCWJfpuSmUFHbHYhP3cLhTh/fiUl518C5KFq8R3B3S57ehzO
         0Pcp5qBi3kgOZmm23eJbQzryyAgILPpWIoxjvlON/HUgZ0POcwhu+0EIMcpAv5t0k1
         hdY5XzMBberHe2iwNvVQRou8MFV/AS1mFpvpAI5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Larry Dewey <larry.dewey@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Borislav Petkov (AMD)" <bp@alien8.de>, stable@kernel.org
Subject: [PATCH 6.2 0847/1001] virt/sev-guest: Return -EIO if certificate buffer is not large enough
Date:   Tue,  7 Mar 2023 18:00:19 +0100
Message-Id: <20230307170058.569605003@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

commit dd093fb08e8f8a958fec4eef36f9f09eac047f60 upstream.

Commit

  47894e0fa6a5 ("virt/sev-guest: Prevent IV reuse in the SNP guest driver")

changed the behavior associated with the return value when the caller
does not supply a large enough certificate buffer. Prior to the commit a
value of -EIO was returned. Now, 0 is returned.  This breaks the
established ABI with the user.

Change the code to detect the buffer size error and return -EIO.

Fixes: 47894e0fa6a5 ("virt/sev-guest: Prevent IV reuse in the SNP guest driver")
Reported-by: Larry Dewey <larry.dewey@amd.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Larry Dewey <larry.dewey@amd.com>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/2afbcae6daf13f7ad5a4296692e0a0fe1bc1e4ee.1677083979.git.thomas.lendacky@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virt/coco/sev-guest/sev-guest.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -377,9 +377,26 @@ static int handle_guest_request(struct s
 		snp_dev->input.data_npages = certs_npages;
 	}
 
+	/*
+	 * Increment the message sequence number. There is no harm in doing
+	 * this now because decryption uses the value stored in the response
+	 * structure and any failure will wipe the VMPCK, preventing further
+	 * use anyway.
+	 */
+	snp_inc_msg_seqno(snp_dev);
+
 	if (fw_err)
 		*fw_err = err;
 
+	/*
+	 * If an extended guest request was issued and the supplied certificate
+	 * buffer was not large enough, a standard guest request was issued to
+	 * prevent IV reuse. If the standard request was successful, return -EIO
+	 * back to the caller as would have originally been returned.
+	 */
+	if (!rc && err == SNP_GUEST_REQ_INVALID_LEN)
+		return -EIO;
+
 	if (rc) {
 		dev_alert(snp_dev->dev,
 			  "Detected error from ASP request. rc: %d, fw_err: %llu\n",
@@ -395,9 +412,6 @@ static int handle_guest_request(struct s
 		goto disable_vmpck;
 	}
 
-	/* Increment to new message sequence after payload decryption was successful. */
-	snp_inc_msg_seqno(snp_dev);
-
 	return 0;
 
 disable_vmpck:


