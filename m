Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9FB35BFD7
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239224AbhDLJHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:07:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:56774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240250AbhDLJFX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:05:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6660B61372;
        Mon, 12 Apr 2021 09:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218151;
        bh=s829YuYmQvJNg/QmsORGD7fyXT0icMCNWFqouhk7faE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zCdPHeKKNlI4Lq4wh4jcDBM+RzPTh2yTcVNne35ekQIdazGY6cId+X3WkYSAbsjtl
         WZBJPiwZWiYyw23ZMVUUDVeICXm+Yek/hn2dfd9T2hnXts8K3tCeuSIr/57A+sGunC
         RAAUVfcqnvLC7ZngpQhqOuIctJczdjr3u11QKlHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ciara Loftus <ciara.loftus@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Subject: [PATCH 5.11 055/210] libbpf: Ensure umem pointer is non-NULL before dereferencing
Date:   Mon, 12 Apr 2021 10:39:20 +0200
Message-Id: <20210412084017.837456288@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ciara Loftus <ciara.loftus@intel.com>

commit df662016310aa4475d7986fd726af45c8fe4f362 upstream.

Calls to xsk_socket__create dereference the umem to access the
fill_save and comp_save pointers. Make sure the umem is non-NULL
before doing this.

Fixes: 2f6324a3937f ("libbpf: Support shared umems between queues and devices")
Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://lore.kernel.org/bpf/20210331061218.1647-2-ciara.loftus@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/lib/bpf/xsk.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -944,6 +944,9 @@ int xsk_socket__create(struct xsk_socket
 		       struct xsk_ring_cons *rx, struct xsk_ring_prod *tx,
 		       const struct xsk_socket_config *usr_config)
 {
+	if (!umem)
+		return -EFAULT;
+
 	return xsk_socket__create_shared(xsk_ptr, ifname, queue_id, umem,
 					 rx, tx, umem->fill_save,
 					 umem->comp_save, usr_config);


