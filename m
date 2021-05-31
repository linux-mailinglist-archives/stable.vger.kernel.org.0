Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE71E3960EE
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbhEaOdc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:33:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:59384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232939AbhEaOb1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:31:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 72DB861C33;
        Mon, 31 May 2021 13:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468946;
        bh=HZ7PRnxunKxxhOBAuhM/r/Gt2HPb3aY6VXxzx1wKkOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YBrc5CXyq+eLweMQ+J3JR8VHWl15TbGt1Kqv19laROq5Vz8UNaClPHaavWbhv+vaE
         FsYJMU0cRN05SGlQsPR4XtAeogr4QWKj9H91U+8/c1gT3ucjEySUxm61xxnTh9XAOP
         OLPC5V9etBivDVMGVH+GLoffHjbzEom5uhlRAHwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.12 011/296] cifs: fix string declarations and assignments in tracepoints
Date:   Mon, 31 May 2021 15:11:06 +0200
Message-Id: <20210531130704.142136798@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

commit eb0688180549e3b72464e9f78df58cb7a5592c7f upstream.

We missed using the variable length string macros in several
tracepoints. Fixed them in this change.

There's probably more useful macros that we can use to print
others like flags etc. But I'll submit sepawrate patches for
those at a future date.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Cc: <stable@vger.kernel.org> # v5.12
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/trace.h |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

--- a/fs/cifs/trace.h
+++ b/fs/cifs/trace.h
@@ -12,6 +12,11 @@
 
 #include <linux/tracepoint.h>
 
+/*
+ * Please use this 3-part article as a reference for writing new tracepoints:
+ * https://lwn.net/Articles/379903/
+ */
+
 /* For logging errors in read or write */
 DECLARE_EVENT_CLASS(smb3_rw_err_class,
 	TP_PROTO(unsigned int xid,
@@ -529,16 +534,16 @@ DECLARE_EVENT_CLASS(smb3_exit_err_class,
 	TP_ARGS(xid, func_name, rc),
 	TP_STRUCT__entry(
 		__field(unsigned int, xid)
-		__field(const char *, func_name)
+		__string(func_name, func_name)
 		__field(int, rc)
 	),
 	TP_fast_assign(
 		__entry->xid = xid;
-		__entry->func_name = func_name;
+		__assign_str(func_name, func_name);
 		__entry->rc = rc;
 	),
 	TP_printk("\t%s: xid=%u rc=%d",
-		__entry->func_name, __entry->xid, __entry->rc)
+		__get_str(func_name), __entry->xid, __entry->rc)
 )
 
 #define DEFINE_SMB3_EXIT_ERR_EVENT(name)          \
@@ -583,14 +588,14 @@ DECLARE_EVENT_CLASS(smb3_enter_exit_clas
 	TP_ARGS(xid, func_name),
 	TP_STRUCT__entry(
 		__field(unsigned int, xid)
-		__field(const char *, func_name)
+		__string(func_name, func_name)
 	),
 	TP_fast_assign(
 		__entry->xid = xid;
-		__entry->func_name = func_name;
+		__assign_str(func_name, func_name);
 	),
 	TP_printk("\t%s: xid=%u",
-		__entry->func_name, __entry->xid)
+		__get_str(func_name), __entry->xid)
 )
 
 #define DEFINE_SMB3_ENTER_EXIT_EVENT(name)        \
@@ -857,16 +862,16 @@ DECLARE_EVENT_CLASS(smb3_reconnect_class
 	TP_STRUCT__entry(
 		__field(__u64, currmid)
 		__field(__u64, conn_id)
-		__field(char *, hostname)
+		__string(hostname, hostname)
 	),
 	TP_fast_assign(
 		__entry->currmid = currmid;
 		__entry->conn_id = conn_id;
-		__entry->hostname = hostname;
+		__assign_str(hostname, hostname);
 	),
 	TP_printk("conn_id=0x%llx server=%s current_mid=%llu",
 		__entry->conn_id,
-		__entry->hostname,
+		__get_str(hostname),
 		__entry->currmid)
 )
 
@@ -891,7 +896,7 @@ DECLARE_EVENT_CLASS(smb3_credit_class,
 	TP_STRUCT__entry(
 		__field(__u64, currmid)
 		__field(__u64, conn_id)
-		__field(char *, hostname)
+		__string(hostname, hostname)
 		__field(int, credits)
 		__field(int, credits_to_add)
 		__field(int, in_flight)
@@ -899,7 +904,7 @@ DECLARE_EVENT_CLASS(smb3_credit_class,
 	TP_fast_assign(
 		__entry->currmid = currmid;
 		__entry->conn_id = conn_id;
-		__entry->hostname = hostname;
+		__assign_str(hostname, hostname);
 		__entry->credits = credits;
 		__entry->credits_to_add = credits_to_add;
 		__entry->in_flight = in_flight;
@@ -907,7 +912,7 @@ DECLARE_EVENT_CLASS(smb3_credit_class,
 	TP_printk("conn_id=0x%llx server=%s current_mid=%llu "
 			"credits=%d credit_change=%d in_flight=%d",
 		__entry->conn_id,
-		__entry->hostname,
+		__get_str(hostname),
 		__entry->currmid,
 		__entry->credits,
 		__entry->credits_to_add,


