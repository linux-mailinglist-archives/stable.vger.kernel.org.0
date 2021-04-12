Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6523535BDF7
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238372AbhDLI4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:56:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238519AbhDLIyL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:54:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3D866128B;
        Mon, 12 Apr 2021 08:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217532;
        bh=NUCp2B5pIVySg9jN5eNWEDvzzGBpF57qj5JKxu0WJpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JF7a68JkpLQIjVbne1ouy6bAPq7VR3cDxSrO9iBoMTOVPMzwLGLKOqQE8E1RZXxmf
         EZqgXzvHH7y/pvNGuMHFqHVxhszONKZ8GwerQUj6P3s/wYmIG6oeQd1B3MbmOKI273
         VhY8ljzaslGAdTgfMIYonfoTGmWBIikmqMEH/Hx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ciara Loftus <ciara.loftus@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Subject: [PATCH 5.10 048/188] libbpf: Ensure umem pointer is non-NULL before dereferencing
Date:   Mon, 12 Apr 2021 10:39:22 +0200
Message-Id: <20210412084015.237539884@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
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
@@ -870,6 +870,9 @@ int xsk_socket__create(struct xsk_socket
 		       struct xsk_ring_cons *rx, struct xsk_ring_prod *tx,
 		       const struct xsk_socket_config *usr_config)
 {
+	if (!umem)
+		return -EFAULT;
+
 	return xsk_socket__create_shared(xsk_ptr, ifname, queue_id, umem,
 					 rx, tx, umem->fill_save,
 					 umem->comp_save, usr_config);


