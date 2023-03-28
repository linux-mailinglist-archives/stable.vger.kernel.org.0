Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44F626CC365
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233356AbjC1Oxi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233411AbjC1Oxc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:53:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DEB5CA38
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:53:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9CD2B81D67
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:53:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FCFCC433D2;
        Tue, 28 Mar 2023 14:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015208;
        bh=QjPEhXJyRBTWMJpyQNqTg4xSZEMThoR2XajJf/Pnwz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cJIawhi8WAcj8knVDhTeOOM/fN6vYsYs8mpJlJHYC2X5uvb/lronirw5O5wCtlTJE
         tNkbFQ2kS5YaCz92gqwb7k8Y5NcRbWkb5QrvkJf0d+Tm0z5J5Iuyacc7cFNcQoCsQz
         7ZGR17KlJwa9FK+uv2rSnMvcIxDNe9+gJ9C2Kp1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shyam Prasad N <sprasad@microsoft.com>,
        "Paulo Alcantara (SUSE)" <pc@manguebit.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.2 164/240] cifs: do not poll server interfaces too regularly
Date:   Tue, 28 Mar 2023 16:42:07 +0200
Message-Id: <20230328142626.507642599@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

commit 072a28c8907c841f7d4b56c78bce46d3ee211e73 upstream.

We have the server interface list hanging off the tcon
structure today for reasons unknown. So each tcon which is
connected to a file server can query them separately,
which is really unnecessary. To avoid this, in the query
function, we will check the time of last update of the
interface list, and avoid querying the server if it is
within a certain range.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2ops.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -530,6 +530,14 @@ parse_server_interfaces(struct network_i
 	p = buf;
 
 	spin_lock(&ses->iface_lock);
+	/* do not query too frequently, this time with lock held */
+	if (ses->iface_last_update &&
+	    time_before(jiffies, ses->iface_last_update +
+			(SMB_INTERFACE_POLL_INTERVAL * HZ))) {
+		spin_unlock(&ses->iface_lock);
+		return 0;
+	}
+
 	/*
 	 * Go through iface_list and do kref_put to remove
 	 * any unused ifaces. ifaces in use will be removed
@@ -696,6 +704,12 @@ SMB3_request_interfaces(const unsigned i
 	struct network_interface_info_ioctl_rsp *out_buf = NULL;
 	struct cifs_ses *ses = tcon->ses;
 
+	/* do not query too frequently */
+	if (ses->iface_last_update &&
+	    time_before(jiffies, ses->iface_last_update +
+			(SMB_INTERFACE_POLL_INTERVAL * HZ)))
+		return 0;
+
 	rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
 			FSCTL_QUERY_NETWORK_INTERFACE_INFO,
 			NULL /* no data input */, 0 /* no data input */,


