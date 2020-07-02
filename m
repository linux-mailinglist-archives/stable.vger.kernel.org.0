Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1CD212931
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 18:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgGBQUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 12:20:11 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14166 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726575AbgGBQUL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jul 2020 12:20:11 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 062G5OQa142291;
        Thu, 2 Jul 2020 12:20:00 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3212atkq29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jul 2020 12:20:00 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 062GIPXI017611;
        Thu, 2 Jul 2020 12:20:00 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3212atkq1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jul 2020 12:19:59 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 062GFvRF008303;
        Thu, 2 Jul 2020 16:19:57 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 31wyyaurhq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Jul 2020 16:19:57 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 062GIZWI57213276
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Jul 2020 16:18:35 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A633A405C;
        Thu,  2 Jul 2020 16:19:55 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90D8AA405F;
        Thu,  2 Jul 2020 16:19:54 +0000 (GMT)
Received: from ozlabs.au.ibm.com (unknown [9.192.253.14])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  2 Jul 2020 16:19:54 +0000 (GMT)
Received: from intelligence.ibm.com (unknown [9.81.218.195])
        (using TLSv1.2 with cipher DHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by ozlabs.au.ibm.com (Postfix) with ESMTPSA id 3C9DBA011E;
        Fri,  3 Jul 2020 02:19:53 +1000 (AEST)
From:   Andrew Donnellan <ajd@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     leobras.c@gmail.com, nathanl@linux.ibm.com,
        Daniel Axtens <dja@axtens.net>, stable@vger.kernel.org
Subject: [PATCH] powerpc/rtas: Restrict RTAS requests from userspace
Date:   Fri,  3 Jul 2020 02:19:32 +1000
Message-Id: <20200702161932.18176-1-ajd@linux.ibm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-02_09:2020-07-02,2020-07-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 cotscore=-2147483648
 spamscore=0 priorityscore=1501 malwarescore=0 clxscore=1011 phishscore=0
 mlxlogscore=999 suspectscore=1 lowpriorityscore=0 mlxscore=0 adultscore=0
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007020111
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A number of userspace utilities depend on making calls to RTAS to retrieve
information and update various things.

The existing API through which we expose RTAS to userspace exposes more
RTAS functionality than we actually need, through the sys_rtas syscall,
which allows root (or anyone with CAP_SYS_ADMIN) to make any RTAS call they
want with arbitrary arguments.

Many RTAS calls take the address of a buffer as an argument, and it's up to
the caller to specify the physical address of the buffer as an argument. We
allocate a buffer (the "RMO buffer") in the Real Memory Area that RTAS can
access, and then expose the physical address and size of this buffer in
/proc/powerpc/rtas/rmo_buffer. Userspace is expected to read this address,
poke at the buffer using /dev/mem, and pass an address in the RMO buffer to
the RTAS call.

However, there's nothing stopping the caller from specifying whatever
address they want in the RTAS call, and it's easy to construct a series of
RTAS calls that can overwrite arbitrary bytes (even without /dev/mem
access).

Additionally, there are some RTAS calls that do potentially dangerous
things and for which there are no legitimate userspace use cases.

In the past, this would not have been a particularly big deal as it was
assumed that root could modify all system state freely, but with Secure
Boot and lockdown we need to care about this.

We can't fundamentally change the ABI at this point, however we can address
this by implementing a filter that checks RTAS calls against a list
of permitted calls and forces the caller to use addresses within the RMO
buffer.

The list is based off the list of calls that are used by the librtas
userspace library, and has been tested with a number of existing userspace
RTAS utilities. For compatibility with any applications we are not aware of
that require other calls, the filter can be turned off at build time.

Reported-by: Daniel Axtens <dja@axtens.net>
Cc: stable@vger.kernel.org
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
---
 arch/powerpc/Kconfig       |  13 +++
 arch/powerpc/kernel/rtas.c | 198 +++++++++++++++++++++++++++++++++++++
 2 files changed, 211 insertions(+)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 9fa23eb320ff..0e2dfe497357 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -973,6 +973,19 @@ config PPC_SECVAR_SYSFS
 	  read/write operations on these variables. Say Y if you have
 	  secure boot enabled and want to expose variables to userspace.
 
+config PPC_RTAS_FILTER
+	bool "Enable filtering of RTAS syscalls"
+	default y
+	depends on PPC_RTAS
+	help
+	  The RTAS syscall API has security issues that could be used to
+	  compromise system integrity. This option enforces restrictions on the
+	  RTAS calls and arguments passed by userspace programs to mitigate
+	  these issues.
+
+	  Say Y unless you know what you are doing and the filter is causing
+	  problems for you.
+
 endmenu
 
 config ISA_DMA_API
diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index a09eba03f180..ec1cae52d8bd 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -324,6 +324,23 @@ int rtas_token(const char *service)
 }
 EXPORT_SYMBOL(rtas_token);
 
+#ifdef CONFIG_PPC_RTAS_FILTER
+
+static char *rtas_token_name(int token)
+{
+	struct property *prop;
+
+	for_each_property_of_node(rtas.dev, prop) {
+		const __be32 *tokp = prop->value;
+
+		if (tokp && be32_to_cpu(*tokp) == token)
+			return prop->name;
+	}
+	return NULL;
+}
+
+#endif /* CONFIG_PPC_RTAS_FILTER */
+
 int rtas_service_present(const char *service)
 {
 	return rtas_token(service) != RTAS_UNKNOWN_SERVICE;
@@ -1110,6 +1127,184 @@ struct pseries_errorlog *get_pseries_errorlog(struct rtas_error_log *log,
 	return NULL;
 }
 
+#ifdef CONFIG_PPC_RTAS_FILTER
+
+/*
+ * The sys_rtas syscall, as originally designed, allows root to pass
+ * arbitrary physical addresses to RTAS calls. A number of RTAS calls
+ * can be abused to write to arbitrary memory and do other things that
+ * are potentially harmful to system integrity, and thus should only
+ * be used inside the kernel and not exposed to userspace.
+ *
+ * All known legitimate users of the sys_rtas syscall will only ever
+ * pass addresses that fall within the RMO buffer, and use a known
+ * subset of RTAS calls.
+ *
+ * Accordingly, we filter RTAS requests to check that the call is
+ * permitted, and that provided pointers fall within the RMO buffer.
+ * The rtas_filters list contains an entry for each permitted call,
+ * with the indexes of the parameters which are expected to contain
+ * addresses and sizes of buffers allocated inside the RMO buffer.
+ */
+struct rtas_filter {
+	const char name[32];
+
+	/* Indexes into the args buffer, -1 if not used */
+	int rmo_buf_idx1;
+	int rmo_size_idx1;
+	int rmo_buf_idx2;
+	int rmo_size_idx2;
+};
+
+struct rtas_filter rtas_filters[] = {
+	{ "ibm,activate-firmware", -1, -1, -1, -1 },
+	{ "ibm,configure-connector", 0, -1, 1, -1 },	/* Special cased, size 4096 */
+	{ "display-character", -1, -1, -1, -1 },
+	{ "ibm,display-message", 0, -1, -1, -1 },
+	{ "ibm,errinjct", 2, -1, -1, -1 },		/* Fixed size of 1024 */
+	{ "ibm,close-errinjct", -1, -1, -1, -1 },
+	{ "ibm,open-errinct", -1, -1, -1, -1 },
+	{ "ibm,get-config-addr-info2", -1, -1, -1, -1 },
+	{ "ibm,get-dynamic-sensor-state", 1, -1, -1, -1 },
+	{ "ibm,get-indices", 2, 3, -1, -1 },
+	{ "get-power-level", -1, -1, -1, -1 },
+	{ "get-sensor-state", -1, -1, -1, -1 },
+	{ "ibm,get-system-parameter", 1, 2, -1, -1 },
+	{ "get-time-of-day", -1, -1, -1, -1 },
+	{ "ibm,get-vpd", 0, -1, 1, 2 },
+	{ "ibm,lpar-perftools", 2, 3, -1, -1 },
+	{ "ibm,platform-dump", 4, 5, -1, -1 },
+	{ "ibm,read-slot-reset-state", -1, -1, -1, -1 },
+	{ "ibm,scan-log-dump", 0, 1, -1, -1 },
+	{ "ibm,set-dynamic-indicator", 2, -1, -1, -1 },
+	{ "ibm,set-eeh-option", -1, -1, -1, -1 },
+	{ "set-indicator", -1, -1, -1, -1 },
+	{ "set-power-level", -1, -1, -1, -1 },
+	{ "set-time-for-power-on", -1, -1, -1, -1 },
+	{ "ibm,set-system-parameter", 1, -1, -1, -1 },
+	{ "set-time-of-day", -1, -1, -1, -1 },
+	{ "ibm,suspend-me", -1, -1, -1, -1 },
+	{ "ibm,update-nodes", 0, -1, -1, -1 },		/* Fixed size of 4096 */
+	{ "ibm,update-properties", 0, -1, -1, -1 },	/* Fixed size of 4096 */
+	{ "ibm,physical-attestation", 0, 1, -1, -1 },
+};
+
+static void dump_rtas_params(int token, int nargs, int nret,
+			     struct rtas_args *args)
+{
+	int i;
+	char *token_name = rtas_token_name(token);
+
+	pr_err_ratelimited("sys_rtas: token=0x%x (%s), nargs=%d, nret=%d (called by %s)\n",
+			   token, token_name ? token_name : "unknown", nargs,
+			   nret, current->comm);
+	pr_err_ratelimited("sys_rtas: args: ");
+
+	for (i = 0; i < nargs; i++) {
+		u32 arg = be32_to_cpu(args->args[i]);
+
+		pr_cont("%08x ", arg);
+		if (arg >= rtas_rmo_buf &&
+		    arg < (rtas_rmo_buf + RTAS_RMOBUF_MAX))
+			pr_cont("(buf+0x%lx) ", arg - rtas_rmo_buf);
+	}
+
+	pr_cont("\n");
+}
+
+static bool in_rmo_buf(u32 base, u32 end)
+{
+	return base >= rtas_rmo_buf &&
+		base < (rtas_rmo_buf + RTAS_RMOBUF_MAX) &&
+		base <= end &&
+		end >= rtas_rmo_buf &&
+		end < (rtas_rmo_buf + RTAS_RMOBUF_MAX);
+}
+
+static bool block_rtas_call(int token, int nargs,
+			    struct rtas_args *args)
+{
+	int i;
+	const char *reason;
+	char *token_name = rtas_token_name(token);
+
+	if (!token_name)
+		goto err_notpermitted;
+
+	for (i = 0; i < ARRAY_SIZE(rtas_filters); i++) {
+		struct rtas_filter *f = &rtas_filters[i];
+		u32 base, size, end;
+
+		if (strcmp(token_name, f->name))
+			continue;
+
+		if (f->rmo_buf_idx1 != -1) {
+			base = be32_to_cpu(args->args[f->rmo_buf_idx1]);
+			if (f->rmo_size_idx1 != -1)
+				size = be32_to_cpu(args->args[f->rmo_size_idx1]);
+			else if (!strcmp(token_name, "ibm,errinjct"))
+				size = 1024;
+			else if (!strcmp(token_name, "ibm,update-nodes") ||
+				 !strcmp(token_name, "ibm,update-properties") ||
+				 !strcmp(token_name, "ibm,configure-connector"))
+				size = 4096;
+			else
+				size = 1;
+
+			end = base + size - 1;
+			if (!in_rmo_buf(base, end)) {
+				reason = "address pair 1 out of range";
+				goto err;
+			}
+		}
+
+		if (f->rmo_buf_idx2 != -1) {
+			base = be32_to_cpu(args->args[f->rmo_buf_idx2]);
+			if (f->rmo_size_idx2 != -1)
+				size = be32_to_cpu(args->args[f->rmo_size_idx2]);
+			else if (!strcmp(token_name, "ibm,configure-connector"))
+				size = 4096;
+			else
+				size = 1;
+			end = base + size - 1;
+
+			/*
+			 * Special case for ibm,configure-connector where the
+			 * address can be 0
+			 */
+			if (!strcmp(token_name, "ibm,configure-connector") &&
+			    base == 0)
+				return false;
+
+			if (!in_rmo_buf(base, end)) {
+				reason = "address pair 2 out of range";
+				goto err;
+			}
+		}
+
+		return false;
+	}
+
+err_notpermitted:
+	reason = "call not permitted";
+
+err:
+	pr_err_ratelimited("sys_rtas: RTAS call blocked - exploit attempt? (%s)\n",
+			   reason);
+	dump_rtas_params(token, nargs, 0, args);
+	return true;
+}
+
+#else
+
+static bool block_rtas_call(int token, int nargs,
+			    struct rtas_args *args)
+{
+	return false;
+}
+
+#endif /* CONFIG_PPC_RTAS_FILTER */
+
 /* We assume to be passed big endian arguments */
 SYSCALL_DEFINE1(rtas, struct rtas_args __user *, uargs)
 {
@@ -1147,6 +1342,9 @@ SYSCALL_DEFINE1(rtas, struct rtas_args __user *, uargs)
 	args.rets = &args.args[nargs];
 	memset(args.rets, 0, nret * sizeof(rtas_arg_t));
 
+	if (block_rtas_call(token, nargs, &args))
+		return -EINVAL;
+
 	/* Need to handle ibm,suspend_me call specially */
 	if (token == ibm_suspend_me_token) {
 
-- 
2.20.1

