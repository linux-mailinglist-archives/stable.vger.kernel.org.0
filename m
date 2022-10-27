Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F23C60FD98
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 18:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235690AbiJ0Q4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 12:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235760AbiJ0Qzx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 12:55:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB038DCAC1
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:55:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91A58623EF
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 16:55:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A22D5C433D7;
        Thu, 27 Oct 2022 16:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666889752;
        bh=QiJYl/0ZnF4hd0m5qqfzZEMa2wB/wbE4dtOkjj7V5uM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Syajmlc2qi8uRttHQZq5h9Sth11V1QIGyfn61DIA5TvL9909PXW8X9dnP8ecU4fhr
         XLgPiqwnsjCpFr3NYJD5e0hZncaOW8G976gyzX/V2VpV8ki29mS88iAYH49kNbU2NE
         /meFCgPlRCepNLmnJOtSP/ssFVNpIXxBCP+VOT3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bharath SM <bharathsm@microsoft.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.0 04/94] smb3: interface count displayed incorrectly
Date:   Thu, 27 Oct 2022 18:54:06 +0200
Message-Id: <20221027165057.358210870@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

commit 096bbeec7bd6fb683831a9ca4850a6b6a3f04740 upstream.

The "Server interfaces" count in /proc/fs/cifs/DebugData increases
as the interfaces are requeried, rather than being reset to the new
value.  This could cause a problem if the server disabled
multichannel as the iface_count is checked in try_adding_channels
to see if multichannel still supported.

Also fixes a coverity warning:

Addresses-Coverity: 1526374 ("Concurrent data access violations  (MISSING_LOCK)")
Cc: <stable@vger.kernel.org>
Reviewed-by: Bharath SM <bharathsm@microsoft.com>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/smb2ops.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -530,6 +530,7 @@ parse_server_interfaces(struct network_i
 	p = buf;
 
 	spin_lock(&ses->iface_lock);
+	ses->iface_count = 0;
 	/*
 	 * Go through iface_list and do kref_put to remove
 	 * any unused ifaces. ifaces in use will be removed
@@ -650,9 +651,9 @@ parse_server_interfaces(struct network_i
 			kref_put(&iface->refcount, release_iface);
 		} else
 			list_add_tail(&info->iface_head, &ses->iface_list);
-		spin_unlock(&ses->iface_lock);
 
 		ses->iface_count++;
+		spin_unlock(&ses->iface_lock);
 		ses->iface_last_update = jiffies;
 next_iface:
 		nb_iface++;


