Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE91D30C104
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 15:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234011AbhBBOMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 09:12:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:49514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233866AbhBBOKy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:10:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12D5F65037;
        Tue,  2 Feb 2021 13:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273872;
        bh=VO72xo3Ln8pM8nOw4InhlEiC5MpY0EvtYKsSSrbihHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tb2+yOQNYIED6om8QVrQnH5QKHADSgCstHpQMtLTBvQF0WCfSdIEWlRPB2WM5/qbV
         /UOJXDqeh2aBKJ4KPC0lzO4o5mcfyKxB9w0wYp448HcpV11z11/cBimlWiQvf50TcK
         wIqqlQY4c1gHjGCWrx8ke3UOqj/2XK7OEPyC8phU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 31/32] NFC: fix resource leak when target index is invalid
Date:   Tue,  2 Feb 2021 14:38:54 +0100
Message-Id: <20210202132943.261191142@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132942.035179752@linuxfoundation.org>
References: <20210202132942.035179752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

commit 3a30537cee233fb7da302491b28c832247d89bbe upstream.

Goto to the label put_dev instead of the label error to fix potential
resource leak on path that the target index is invalid.

Fixes: c4fbb6515a4d ("NFC: The core part should generate the target index")
Signed-off-by: Pan Bian <bianpan2016@163.com>
Link: https://lore.kernel.org/r/20210121152748.98409-1-bianpan2016@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/nfc/rawsock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/nfc/rawsock.c
+++ b/net/nfc/rawsock.c
@@ -117,7 +117,7 @@ static int rawsock_connect(struct socket
 	if (addr->target_idx > dev->target_next_idx - 1 ||
 	    addr->target_idx < dev->target_next_idx - dev->n_targets) {
 		rc = -EINVAL;
-		goto error;
+		goto put_dev;
 	}
 
 	rc = nfc_activate_target(dev, addr->target_idx, addr->nfc_protocol);


