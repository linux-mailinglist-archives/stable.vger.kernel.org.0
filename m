Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C376E451E76
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243626AbhKPAgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:36:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:45388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344970AbhKOTZw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58383633FE;
        Mon, 15 Nov 2021 19:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003261;
        bh=ig0hJiKTYvtkZazunsf01HBqGfvfe21uZdqzF7JLj00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0+al4gFG4kr/kHP5knO3uCHe9/GKDDS972AYzc/zKnRIasM8wFgyxaAcAA/0nbKo3
         XgHUAiIWE5F1PUlCDT5wq6/1iUAWRutIDvfDbth1BIidV+HHe4r9OzILh6A38t9rId
         AvTy41qUXetpT1mW5m2skcqyJO658B9PP92X7+r0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyunchul Lee <hyc.lee@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 870/917] ksmbd: dont need 8byte alignment for request length in ksmbd_check_message
Date:   Mon, 15 Nov 2021 18:06:05 +0100
Message-Id: <20211115165458.554873416@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

commit b53ad8107ee873795ecb5039d46b5d5502d404f2 upstream.

When validating request length in ksmbd_check_message, 8byte alignment
is not needed for compound request. It can cause wrong validation
of request length.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org # v5.15
Acked-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2misc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -358,12 +358,10 @@ int ksmbd_smb2_check_message(struct ksmb
 		hdr = &pdu->hdr;
 	}
 
-	if (le32_to_cpu(hdr->NextCommand) > 0) {
+	if (le32_to_cpu(hdr->NextCommand) > 0)
 		len = le32_to_cpu(hdr->NextCommand);
-	} else if (work->next_smb2_rcv_hdr_off) {
+	else if (work->next_smb2_rcv_hdr_off)
 		len -= work->next_smb2_rcv_hdr_off;
-		len = round_up(len, 8);
-	}
 
 	if (check_smb2_hdr(hdr))
 		return 1;


