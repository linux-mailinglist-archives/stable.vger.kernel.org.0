Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18EE9205F68
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387542AbgFWUci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:32:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:53516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391332AbgFWUcg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:32:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 507F220702;
        Tue, 23 Jun 2020 20:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944355;
        bh=Qrr1m8gojHbUX+fhFTpH2yIQvrlfbVIgli/PbtQG+OU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hY11oDHlecZVKj7OhHMGIM4kzzedh3736QmZuHDIvAybt4myDuth3XAKilj//UEZG
         21xQisl1+5b288D3lNFnAhra4w8Cn1S5lseMlD6WqALVESaIztHjEYKKXx/b1QjBUW
         3J5L1ykDESPMR4BmpH9XosriKuEaodFsKZ2IABag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 273/314] afs: Fix the mapping of the UAEOVERFLOW abort code
Date:   Tue, 23 Jun 2020 21:57:48 +0200
Message-Id: <20200623195352.007615514@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 4ec89596d06bd481ba827f3b409b938d63914157 ]

Abort code UAEOVERFLOW is returned when we try and set a time that's out of
range, but it's currently mapped to EREMOTEIO by the default case.

Fix UAEOVERFLOW to map instead to EOVERFLOW.

Found with the generic/258 xfstest.  Note that the test is wrong as it
assumes that the filesystem will support a pre-UNIX-epoch date.

Fixes: 1eda8bab70ca ("afs: Add support for the UAE error table")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/misc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/afs/misc.c b/fs/afs/misc.c
index 52b19e9c15351..5334f1bd2bca7 100644
--- a/fs/afs/misc.c
+++ b/fs/afs/misc.c
@@ -83,6 +83,7 @@ int afs_abort_to_error(u32 abort_code)
 	case UAENOLCK:			return -ENOLCK;
 	case UAENOTEMPTY:		return -ENOTEMPTY;
 	case UAELOOP:			return -ELOOP;
+	case UAEOVERFLOW:		return -EOVERFLOW;
 	case UAENOMEDIUM:		return -ENOMEDIUM;
 	case UAEDQUOT:			return -EDQUOT;
 
-- 
2.25.1



