Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40A58E69A9
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbfJ0VEa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:04:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728627AbfJ0VE1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:04:27 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4D4D2064A;
        Sun, 27 Oct 2019 21:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210266;
        bh=EVUNZKsf8salVAcey8QhyzO1w7hAWnsfMPL7deYWGnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RVwStQZt+tjYsp083zUxAoh/gC1hjXQH8OQ95OjlArwrC2xvDgnJiTZhZ1qj6pefV
         5n0RQ8Q612DtcBbqiefskqZ6mCzxUZhFKHJ8V9WGuXb6J/vBU/88roo0Tk0Dbom8YH
         MQX67HWfZQc997bXKq9t0B/PSSka+2irECGwPjSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Roberto Bergantinos Corpas <rbergant@redhat.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 4.4 34/41] CIFS: avoid using MID 0xFFFF
Date:   Sun, 27 Oct 2019 22:01:12 +0100
Message-Id: <20191027203127.965834641@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203056.220821342@linuxfoundation.org>
References: <20191027203056.220821342@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roberto Bergantinos Corpas <rbergant@redhat.com>

commit 03d9a9fe3f3aec508e485dd3dcfa1e99933b4bdb upstream.

According to MS-CIFS specification MID 0xFFFF should not be used by the
CIFS client, but we actually do. Besides, this has proven to cause races
leading to oops between SendReceive2/cifs_demultiplex_thread. On SMB1,
MID is a 2 byte value easy to reach in CurrentMid which may conflict with
an oplock break notification request coming from server

Signed-off-by: Roberto Bergantinos Corpas <rbergant@redhat.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
CC: Stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb1ops.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -180,6 +180,9 @@ cifs_get_next_mid(struct TCP_Server_Info
 	/* we do not want to loop forever */
 	last_mid = cur_mid;
 	cur_mid++;
+	/* avoid 0xFFFF MID */
+	if (cur_mid == 0xffff)
+		cur_mid++;
 
 	/*
 	 * This nested loop looks more expensive than it is.


