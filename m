Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0597150CBF
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730708AbgBCQjD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:39:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:53766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731428AbgBCQiA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:38:00 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 885AE2087E;
        Mon,  3 Feb 2020 16:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747879;
        bh=tfUQ0OtFWUwt3ZmIEKievnhC9gC19+ww/xJKGMsOyjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=si1Rx+hhZjZlc+wWiNwSDvBXg5HIXzvwN6JlVoRphAWhLgW9ZQ8RvGuTELs7oXFFH
         PCJCFhBb+thtAVbXOkb58ICpn5Qxu/96MqKkUQg2O8bvDWV/ofmdAMuk656EooNl+2
         h2yd7XRCd6pEQLr4T5CPKEIqce1ucvF+O5DGU/ZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        "Paulo Alcantara (SUSE)" <pc@cjr.nz>
Subject: [PATCH 5.5 02/23] cifs: fix soft mounts hanging in the reconnect code
Date:   Mon,  3 Feb 2020 16:20:22 +0000
Message-Id: <20200203161903.435449312@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161902.288335885@linuxfoundation.org>
References: <20200203161902.288335885@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

commit c54849ddd832ae0a45cab16bcd1ed2db7da090d7 upstream.

RHBZ: 1795429

In recent DFS updates we have a new variable controlling how many times we will
retry to reconnect the share.
If DFS is not used, then this variable is initialized to 0 in:

static inline int
dfs_cache_get_nr_tgts(const struct dfs_cache_tgt_list *tl)
{
        return tl ? tl->tl_numtgts : 0;
}

This means that in the reconnect loop in smb2_reconnect() we will immediately wrap retries to -1
and never actually get to pass this conditional:

                if (--retries)
                        continue;

The effect is that we no longer reach the point where we fail the commands with -EHOSTDOWN
and basically the kernel threads are virtually hung and unkillable.

Fixes: a3a53b7603798fd8 (cifs: Add support for failover in smb2_reconnect())
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
CC: Stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2pdu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -312,7 +312,7 @@ smb2_reconnect(__le16 smb2_command, stru
 		if (server->tcpStatus != CifsNeedReconnect)
 			break;
 
-		if (--retries)
+		if (retries && --retries)
 			continue;
 
 		/*


