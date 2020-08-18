Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B04924863D
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 15:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgHRNk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 09:40:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726612AbgHRNkM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 09:40:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E203A206B5;
        Tue, 18 Aug 2020 13:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597758011;
        bh=Mfor1aJi+OpkKSi/XJjUAzsMcNX21INixvXSv4acO+8=;
        h=Subject:To:From:Date:From;
        b=kng3WXaeQbpb8wCSW68Io8P0t+RwP1WPo95SsMSmD7nHxou7u8bP0jddIT2eQBHmA
         ce7k+hKLSr+PywklDcZ8csxsLcovuCtD0TsB1rwHf0DmPKrfMVHMMek5EC+iALJ1VK
         fchb9iDJIJlhmlyuLPfxbxXWRUm5SLllygo9iY8o=
Subject: patch "mei: hdcp: fix mei_hdcp_verify_mprime() input parameter" added to char-misc-linus
To:     tomas.winkler@intel.com, gregkh@linuxfoundation.org,
        gustavoars@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 18 Aug 2020 15:40:35 +0200
Message-ID: <15977580352193@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    mei: hdcp: fix mei_hdcp_verify_mprime() input parameter

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 51072c0f5b5e98a035c6f63b83ba2afedbb7accd Mon Sep 17 00:00:00 2001
From: Tomas Winkler <tomas.winkler@intel.com>
Date: Tue, 18 Aug 2020 10:54:06 +0300
Subject: mei: hdcp: fix mei_hdcp_verify_mprime() input parameter

wired_cmd_repeater_auth_stream_req_in has a variable
length array at the end. we use struct_size() overflow
macro to determine the size for the allocation and sending
size.
This also fixes bug in case number of streams is > 0 in the original
submission. This bug was not triggered as the number of streams is
always one.

Fixes: c56967d674e3 (mei: hdcp: Replace one-element array with flexible-array member)
Fixes: 0a1af1b5c18d (misc/mei/hdcp: Verify M_prime)
Cc: <stable@vger.kernel.org> # v5.1+: c56967d674e3 (mei: hdcp: Replace one-element array with flexible-array member)
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/r/20200818075406.2532605-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hdcp/mei_hdcp.c | 40 +++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/drivers/misc/mei/hdcp/mei_hdcp.c b/drivers/misc/mei/hdcp/mei_hdcp.c
index d1d3e025ca0e..9ae9669e46ea 100644
--- a/drivers/misc/mei/hdcp/mei_hdcp.c
+++ b/drivers/misc/mei/hdcp/mei_hdcp.c
@@ -546,38 +546,46 @@ static int mei_hdcp_verify_mprime(struct device *dev,
 				  struct hdcp_port_data *data,
 				  struct hdcp2_rep_stream_ready *stream_ready)
 {
-	struct wired_cmd_repeater_auth_stream_req_in
-					verify_mprime_in = { { 0 } };
+	struct wired_cmd_repeater_auth_stream_req_in *verify_mprime_in;
 	struct wired_cmd_repeater_auth_stream_req_out
 					verify_mprime_out = { { 0 } };
 	struct mei_cl_device *cldev;
 	ssize_t byte;
+	size_t cmd_size;
 
 	if (!dev || !stream_ready || !data)
 		return -EINVAL;
 
 	cldev = to_mei_cl_device(dev);
 
-	verify_mprime_in.header.api_version = HDCP_API_VERSION;
-	verify_mprime_in.header.command_id = WIRED_REPEATER_AUTH_STREAM_REQ;
-	verify_mprime_in.header.status = ME_HDCP_STATUS_SUCCESS;
-	verify_mprime_in.header.buffer_len =
+	cmd_size = struct_size(verify_mprime_in, streams, data->k);
+	if (cmd_size == SIZE_MAX)
+		return -EINVAL;
+
+	verify_mprime_in = kzalloc(cmd_size, GFP_KERNEL);
+	if (!verify_mprime_in)
+		return -ENOMEM;
+
+	verify_mprime_in->header.api_version = HDCP_API_VERSION;
+	verify_mprime_in->header.command_id = WIRED_REPEATER_AUTH_STREAM_REQ;
+	verify_mprime_in->header.status = ME_HDCP_STATUS_SUCCESS;
+	verify_mprime_in->header.buffer_len =
 			WIRED_CMD_BUF_LEN_REPEATER_AUTH_STREAM_REQ_MIN_IN;
 
-	verify_mprime_in.port.integrated_port_type = data->port_type;
-	verify_mprime_in.port.physical_port = (u8)data->fw_ddi;
-	verify_mprime_in.port.attached_transcoder = (u8)data->fw_tc;
+	verify_mprime_in->port.integrated_port_type = data->port_type;
+	verify_mprime_in->port.physical_port = (u8)data->fw_ddi;
+	verify_mprime_in->port.attached_transcoder = (u8)data->fw_tc;
+
+	memcpy(verify_mprime_in->m_prime, stream_ready->m_prime, HDCP_2_2_MPRIME_LEN);
+	drm_hdcp_cpu_to_be24(verify_mprime_in->seq_num_m, data->seq_num_m);
 
-	memcpy(verify_mprime_in.m_prime, stream_ready->m_prime,
-	       HDCP_2_2_MPRIME_LEN);
-	drm_hdcp_cpu_to_be24(verify_mprime_in.seq_num_m, data->seq_num_m);
-	memcpy(verify_mprime_in.streams, data->streams,
+	memcpy(verify_mprime_in->streams, data->streams,
 	       array_size(data->k, sizeof(*data->streams)));
 
-	verify_mprime_in.k = cpu_to_be16(data->k);
+	verify_mprime_in->k = cpu_to_be16(data->k);
 
-	byte = mei_cldev_send(cldev, (u8 *)&verify_mprime_in,
-			      sizeof(verify_mprime_in));
+	byte = mei_cldev_send(cldev, (u8 *)verify_mprime_in, cmd_size);
+	kfree(verify_mprime_in);
 	if (byte < 0) {
 		dev_dbg(dev, "mei_cldev_send failed. %zd\n", byte);
 		return byte;
-- 
2.28.0


