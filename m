Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E662C3C48EF
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235700AbhGLGlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:41:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237275AbhGLGjV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:39:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E08E6611B0;
        Mon, 12 Jul 2021 06:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071696;
        bh=cURFvA4Jf7l4CwOYpQGRCuP5EibVf4sASovRx07Poxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XyCraxS22ytSrXQEtqwITUQ2BSH5LL5rIB+ov5oq76i0TSXFzdNrccqQboA8a53y9
         IIdXkmkyTVd2TAqQRgN58joSVDWns8x58oqCnmzmBJcy65+c/xt2FmTMYeMywty/Oc
         cnwqLdHsy7edqZm7TEdenDaOSWliPki5TnCPoQRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 180/593] fs: dlm: cancel work sync othercon
Date:   Mon, 12 Jul 2021 08:05:40 +0200
Message-Id: <20210712060902.842172734@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit c6aa00e3d20c2767ba3f57b64eb862572b9744b3 ]

These rx tx flags arguments are for signaling close_connection() from
which worker they are called. Obviously the receive worker cannot cancel
itself and vice versa for swork. For the othercon the receive worker
should only be used, however to avoid deadlocks we should pass the same
flags as the original close_connection() was called.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dlm/lowcomms.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 44e2716ac158..0c78fdfb1f6f 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -599,7 +599,7 @@ static void close_connection(struct connection *con, bool and_other,
 	}
 	if (con->othercon && and_other) {
 		/* Will only re-enter once. */
-		close_connection(con->othercon, false, true, true);
+		close_connection(con->othercon, false, tx, rx);
 	}
 
 	con->rx_leftover = 0;
-- 
2.30.2



