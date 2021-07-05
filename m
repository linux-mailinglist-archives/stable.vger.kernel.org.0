Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0193BBF0E
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 17:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbhGEPbS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 11:31:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:55784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231954AbhGEPbQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 11:31:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 445EB61973;
        Mon,  5 Jul 2021 15:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625498918;
        bh=csfxoKmzrHeJmjCAIHQ484RFD0PPN1Sp7qtZ5dj0pAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V+i4m4r7FIJs1NwMXKd4pw7lSrBKuQ0T8yXeshCRN8rl/K2twbgCNkzCP4kmqlr91
         5fz5JCxstwct+i5p7gMw+kWjtFAso1R2Ra+Z/G5D4Gm2ZvmhZU0wJ+2MJ7aXbA8Pnb
         RZIjKWWyo4/Vm8hoSGAMaaeGnX4Ld3C5q3kP45IiKIRu1kTgEoxvFWqYIcoxW5DUhg
         gKrvH+gJb+7ppZUuLuHgq5G4wVP9ZxbBrff1f1S+m6YzIszDG4OlaBAk+dzpqg956I
         QY5pHSc+cKtv/tIEa7o4puFiYRe6W8h08+JMi5SI76KUrRJsADIbCP5QF0MbvsVro8
         vPZzcKAOpD7yg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.13 17/59] fs: dlm: cancel work sync othercon
Date:   Mon,  5 Jul 2021 11:27:33 -0400
Message-Id: <20210705152815.1520546-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210705152815.1520546-1-sashal@kernel.org>
References: <20210705152815.1520546-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index cdc50e9a5ab0..138e8236ff6e 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -715,7 +715,7 @@ static void close_connection(struct connection *con, bool and_other,
 
 	if (con->othercon && and_other) {
 		/* Will only re-enter once. */
-		close_connection(con->othercon, false, true, true);
+		close_connection(con->othercon, false, tx, rx);
 	}
 
 	con->rx_leftover = 0;
-- 
2.30.2

