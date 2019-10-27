Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED61DE682A
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732589AbfJ0VYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:24:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732581AbfJ0VYp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:24:45 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65C39222C2;
        Sun, 27 Oct 2019 21:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211484;
        bh=Ylppbfu16KHMXB+7ecukrBDTkQE1TIOrkKxPPDpLHY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EmlUvbIxhKsFCq3yvyjorWbkZDsQKgyeBbTqv4MDP1/lrRm5Il3eFD24ceDQ491Vu
         fZW68+CTpqJIQ3wDq0thNK8hhRhtaNYSay6erwwMZ2VVfCgCOudDSiOa88fPVJOv6W
         pHHkmuchAPO42zn48Nsnk7FfsLn+I/OhWN2B1uPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Roberto Bergantinos Corpas <rbergant@redhat.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.3 167/197] CIFS: avoid using MID 0xFFFF
Date:   Sun, 27 Oct 2019 22:01:25 +0100
Message-Id: <20191027203403.359847100@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
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
@@ -171,6 +171,9 @@ cifs_get_next_mid(struct TCP_Server_Info
 	/* we do not want to loop forever */
 	last_mid = cur_mid;
 	cur_mid++;
+	/* avoid 0xFFFF MID */
+	if (cur_mid == 0xffff)
+		cur_mid++;
 
 	/*
 	 * This nested loop looks more expensive than it is.


