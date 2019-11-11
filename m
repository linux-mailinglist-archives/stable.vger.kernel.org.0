Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A66A4F7D20
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbfKKSxc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:53:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:48292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730389AbfKKSxa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:53:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C067520818;
        Mon, 11 Nov 2019 18:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498409;
        bh=5b8/2op+ItCBvm/1g6xyyc4i0Q7+o/zfLH0FOPa8fHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=15kwTQ0EGxeXsCO060QdvyRzbZ/gNQ+TNu0FSgJ/pHCgioR8k/vpTBqlNvNXBypUN
         J2vDpb4u7vk+kUspvzhzUPP1qmAK9pUdjiYjsa44pBQb6a9GeOonRQ4IU81t+aafaU
         aZoqRHdU8fswqA1+lOJNwGE3WoNWgrTB4YEssnVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.3 071/193] SMB3: Fix persistent handles reconnect
Date:   Mon, 11 Nov 2019 19:27:33 +0100
Message-Id: <20191111181506.350324816@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Shilovsky <pshilov@microsoft.com>

commit d243af7ab9feb49f11f2c0050d2077e2d9556f9b upstream.

When the client hits a network reconnect, it re-opens every open
file with a create context to reconnect a persistent handle. All
create context types should be 8-bytes aligned but the padding
was missed for that one. As a result, some servers don't allow
us to reconnect handles and return an error. The problem occurs
when the problematic context is not at the end of the create
request packet. Fix this by adding a proper padding at the end
of the reconnect persistent handle context.

Cc: Stable <stable@vger.kernel.org> # 4.19.x
Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2pdu.h |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -836,6 +836,7 @@ struct create_durable_handle_reconnect_v
 	struct create_context ccontext;
 	__u8   Name[8];
 	struct durable_reconnect_context_v2 dcontext;
+	__u8   Pad[4];
 } __packed;
 
 /* See MS-SMB2 2.2.13.2.5 */


