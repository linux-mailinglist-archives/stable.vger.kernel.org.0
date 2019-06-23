Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1EFF4FC8E
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 18:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbfFWQCA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jun 2019 12:02:00 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:43187 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726399AbfFWQB7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jun 2019 12:01:59 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 0CDC42102F;
        Sun, 23 Jun 2019 12:01:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 23 Jun 2019 12:01:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ycJoBy
        DJRF4/DUppyv6t2aO5YcsE9Af+Lx8ZVVV+lQk=; b=hsJLmyyZKSReDnnYSFd4zT
        bu/xztOsaaUkYnUD0Z3BMJMxidmO5MYsHtCWtK1iFXrbwQbz+cP5R7j74VWKrBTv
        8SFNbf3sEPmUJut4LC5WLno6im0tsQHqoIjouQ7HmiL1ruV0i1rcm3IVg87m+M34
        viRdIj/SlOr+E0Pj/PN3OmvgFPCmrwJ4zKGKTCTXms1t87IzYapSrVrLYFdsggxc
        t/j50G1PdPpB3fazDedo6YbUazE0WEJNY4nbTRGaSmf5YlwijinYlPc5MdiJwTkX
        LW48i+IRr6u6msTKpAIemRSH+uxp25TdIl8h5cbguM08Fa0L1RKymJpZryElVGoA
        ==
X-ME-Sender: <xms:dqIPXcuk_YsPqdV-VUEamWxt8U5GU8TN3Lz-A-j6iY-_t_N7jQ7dww>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtgddutddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekgedrvdeguddrudeliedrvddvtdenucfrrghrrghmpehmrghilhhfrh
    homhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:dqIPXZ4ERJFNu7-jVmZlv_t-VSYm4jwcwe0BbDKSt1ZsCeU0Djr9hQ>
    <xmx:dqIPXZOBJuhi5MdXc1Incy0rkowARyRzG0jZ5BdgoDEcPeKg_YiFhA>
    <xmx:dqIPXfNk_oo9SubB5vA4fRrySC9NlRBQweaNAxde41TPKY9Nz_WHrA>
    <xmx:d6IPXSzAT03g7zMmpt5eizxkx-tCpXntKqOMhF3JGHgS46SVboqPhw>
Received: from localhost (unknown [84.241.196.220])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4EBB38005B;
        Sun, 23 Jun 2019 12:01:58 -0400 (EDT)
Subject: FAILED: patch "[PATCH] apparmor: reset pos on failure to unpack for various" failed to apply to 4.9-stable tree
To:     mike.salvatore@canonical.com, john.johansen@canonical.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jun 2019 18:01:45 +0200
Message-ID: <1561305705156102@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 156e42996bd84eccb6acf319f19ce0cb140d00e3 Mon Sep 17 00:00:00 2001
From: Mike Salvatore <mike.salvatore@canonical.com>
Date: Wed, 12 Jun 2019 14:55:14 -0700
Subject: [PATCH] apparmor: reset pos on failure to unpack for various
 functions

Each function that manipulates the aa_ext struct should reset it's "pos"
member on failure. This ensures that, on failure, no changes are made to
the state of the aa_ext struct.

There are paths were elements are optional and the error path is
used to indicate the optional element is not present. This means
instead of just aborting on error the unpack stream can become
unsynchronized on optional elements, if using one of the affected
functions.

Cc: stable@vger.kernel.org
Fixes: 736ec752d95e ("AppArmor: policy routines for loading and unpacking policy")
Signed-off-by: Mike Salvatore <mike.salvatore@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>

diff --git a/security/apparmor/policy_unpack.c b/security/apparmor/policy_unpack.c
index 005a705346f0..8cfc9493eefc 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -219,16 +219,21 @@ static void *kvmemdup(const void *src, size_t len)
 static size_t unpack_u16_chunk(struct aa_ext *e, char **chunk)
 {
 	size_t size = 0;
+	void *pos = e->pos;
 
 	if (!inbounds(e, sizeof(u16)))
-		return 0;
+		goto fail;
 	size = le16_to_cpu(get_unaligned((__le16 *) e->pos));
 	e->pos += sizeof(__le16);
 	if (!inbounds(e, size))
-		return 0;
+		goto fail;
 	*chunk = e->pos;
 	e->pos += size;
 	return size;
+
+fail:
+	e->pos = pos;
+	return 0;
 }
 
 /* unpack control byte */
@@ -290,62 +295,84 @@ static bool unpack_nameX(struct aa_ext *e, enum aa_code code, const char *name)
 
 static bool unpack_u8(struct aa_ext *e, u8 *data, const char *name)
 {
+	void *pos = e->pos;
+
 	if (unpack_nameX(e, AA_U8, name)) {
 		if (!inbounds(e, sizeof(u8)))
-			return 0;
+			goto fail;
 		if (data)
 			*data = get_unaligned((u8 *)e->pos);
 		e->pos += sizeof(u8);
 		return 1;
 	}
+
+fail:
+	e->pos = pos;
 	return 0;
 }
 
 static bool unpack_u32(struct aa_ext *e, u32 *data, const char *name)
 {
+	void *pos = e->pos;
+
 	if (unpack_nameX(e, AA_U32, name)) {
 		if (!inbounds(e, sizeof(u32)))
-			return 0;
+			goto fail;
 		if (data)
 			*data = le32_to_cpu(get_unaligned((__le32 *) e->pos));
 		e->pos += sizeof(u32);
 		return 1;
 	}
+
+fail:
+	e->pos = pos;
 	return 0;
 }
 
 static bool unpack_u64(struct aa_ext *e, u64 *data, const char *name)
 {
+	void *pos = e->pos;
+
 	if (unpack_nameX(e, AA_U64, name)) {
 		if (!inbounds(e, sizeof(u64)))
-			return 0;
+			goto fail;
 		if (data)
 			*data = le64_to_cpu(get_unaligned((__le64 *) e->pos));
 		e->pos += sizeof(u64);
 		return 1;
 	}
+
+fail:
+	e->pos = pos;
 	return 0;
 }
 
 static size_t unpack_array(struct aa_ext *e, const char *name)
 {
+	void *pos = e->pos;
+
 	if (unpack_nameX(e, AA_ARRAY, name)) {
 		int size;
 		if (!inbounds(e, sizeof(u16)))
-			return 0;
+			goto fail;
 		size = (int)le16_to_cpu(get_unaligned((__le16 *) e->pos));
 		e->pos += sizeof(u16);
 		return size;
 	}
+
+fail:
+	e->pos = pos;
 	return 0;
 }
 
 static size_t unpack_blob(struct aa_ext *e, char **blob, const char *name)
 {
+	void *pos = e->pos;
+
 	if (unpack_nameX(e, AA_BLOB, name)) {
 		u32 size;
 		if (!inbounds(e, sizeof(u32)))
-			return 0;
+			goto fail;
 		size = le32_to_cpu(get_unaligned((__le32 *) e->pos));
 		e->pos += sizeof(u32);
 		if (inbounds(e, (size_t) size)) {
@@ -354,6 +381,9 @@ static size_t unpack_blob(struct aa_ext *e, char **blob, const char *name)
 			return size;
 		}
 	}
+
+fail:
+	e->pos = pos;
 	return 0;
 }
 
@@ -370,9 +400,10 @@ static int unpack_str(struct aa_ext *e, const char **string, const char *name)
 			if (src_str[size - 1] != 0)
 				goto fail;
 			*string = src_str;
+
+			return size;
 		}
 	}
-	return size;
 
 fail:
 	e->pos = pos;

