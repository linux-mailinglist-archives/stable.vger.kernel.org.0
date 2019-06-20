Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB5C4D6D8
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729122AbfFTSMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:12:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38908 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729112AbfFTSMw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jun 2019 14:12:52 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1he1YH-00077r-RV; Thu, 20 Jun 2019 19:12:49 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1he1YH-000619-8k; Thu, 20 Jun 2019 19:12:49 +0100
Message-ID: <3b166395826ff6cc5ae8477b4fd5ec6f88005804.camel@decadent.org.uk>
Subject: Linux 3.16.69
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc:     lwn@lwn.net
Date:   Thu, 20 Jun 2019 19:12:48 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-0TO52R/JStVqR/4csUtx"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-0TO52R/JStVqR/4csUtx
Content-Type: multipart/mixed; boundary="=-TCiGxj4hJ2DGJI8Kw6Tn"


--=-TCiGxj4hJ2DGJI8Kw6Tn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.16.69 kernel.

All users of the 3.16 kernel series should upgrade.

The updated 3.16.y git tree can be found at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
.git linux-3.16.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.gi=
t

The diff from 3.16.68 is attached to this message.

Ben.

------------

 Documentation/networking/ip-sysctl.txt    |  8 ++++++++
 Makefile                                  |  2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c |  1 +
 drivers/virt/fsl_hypervisor.c             |  3 +++
 fs/ext4/extents.c                         | 17 +++++++++++++++--
 include/linux/mm.h                        |  5 +++++
 include/linux/tcp.h                       |  3 +++
 include/net/tcp.h                         |  3 +++
 include/uapi/linux/snmp.h                 |  1 +
 mm/memory.c                               |  8 ++++----
 mm/mincore.c                              | 21 +++++++++++++++++++++
 net/bluetooth/hidp/sock.c                 |  1 +
 net/ipv4/proc.c                           |  1 +
 net/ipv4/sysctl_net_ipv4.c                | 11 +++++++++++
 net/ipv4/tcp.c                            |  1 +
 net/ipv4/tcp_input.c                      | 27 ++++++++++++++++++++++-----
 net/ipv4/tcp_output.c                     |  9 +++++++--
 net/ipv4/tcp_timer.c                      |  1 +
 18 files changed, 109 insertions(+), 14 deletions(-)

Ben Hutchings (1):
      Linux 3.16.69

Dan Carpenter (1):
      drivers/virt/fsl_hypervisor.c: prevent integer overflow in ioctl

Eric Dumazet (4):
      tcp: limit payload size of sacked skbs
      tcp: tcp_fragment() should apply sane memory limits
      tcp: add tcp_min_snd_mss sysctl
      tcp: enforce tcp_min_snd_mss in tcp_mtu_probing()

Jason Yan (1):
      scsi: megaraid_sas: return error when create DMA pool failed

Jiri Kosina (1):
      mm/mincore.c: make mincore() more conservative

Oleg Nesterov (1):
      mm: introduce vma_is_anonymous(vma) helper

Sriram Rajagopalan (1):
      ext4: zero out the unused memory region in the extent tree block

Young Xiao (1):
      Bluetooth: hidp: fix buffer overflow

--=20
Ben Hutchings
Beware of programmers who carry screwdrivers. - Leonard Brandwein



--=-TCiGxj4hJ2DGJI8Kw6Tn
Content-Type: text/x-diff; charset="UTF-8"; name="linux-3.16.69.patch"
Content-Disposition: attachment; filename="linux-3.16.69.patch"
Content-Transfer-Encoding: quoted-printable

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/network=
ing/ip-sysctl.txt
index 36aa39eee48f..6020d179e56f 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -210,6 +210,14 @@ tcp_base_mss - INTEGER
 	Path MTU discovery (MTU probing).  If MTU probing is enabled,
 	this is the initial MSS used by the connection.
=20
+tcp_min_snd_mss - INTEGER
+	TCP SYN and SYNACK messages usually advertise an ADVMSS option,
+	as described in RFC 1122 and RFC 6691.
+	If this ADVMSS option is smaller than tcp_min_snd_mss,
+	it is silently capped to tcp_min_snd_mss.
+
+	Default : 48 (at least 8 bytes of payload per segment)
+
 tcp_congestion_control - STRING
 	Set the congestion control algorithm to be used for new
 	connections. The algorithm "reno" is always available, but
diff --git a/Makefile b/Makefile
index 7763a879e9d5..e9a1864ac58e 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION =3D 3
 PATCHLEVEL =3D 16
-SUBLEVEL =3D 68
+SUBLEVEL =3D 69
 EXTRAVERSION =3D
 NAME =3D Museum of Fishiegoodies
=20
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megar=
aid/megaraid_sas_base.c
index 9b66d42fa971..a63896727aae 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3489,6 +3489,7 @@ int megasas_alloc_cmds(struct megasas_instance *insta=
nce)
 	if (megasas_create_frame_pool(instance)) {
 		printk(KERN_DEBUG "megasas: Error creating frame DMA pool\n");
 		megasas_free_cmds(instance);
+		return -ENOMEM;
 	}
=20
 	return 0;
diff --git a/drivers/virt/fsl_hypervisor.c b/drivers/virt/fsl_hypervisor.c
index 32c8fc5f7a5c..7c95e0a8f68b 100644
--- a/drivers/virt/fsl_hypervisor.c
+++ b/drivers/virt/fsl_hypervisor.c
@@ -215,6 +215,9 @@ static long ioctl_memcpy(struct fsl_hv_ioctl_memcpy __u=
ser *p)
 	 * hypervisor.
 	 */
 	lb_offset =3D param.local_vaddr & (PAGE_SIZE - 1);
+	if (param.count =3D=3D 0 ||
+	    param.count > U64_MAX - lb_offset - PAGE_SIZE + 1)
+		return -EINVAL;
 	num_pages =3D (param.count + lb_offset + PAGE_SIZE - 1) >> PAGE_SHIFT;
=20
 	/* Allocate the buffers we need */
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 289562c42511..3bb1153827d8 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1016,6 +1016,7 @@ static int ext4_ext_split(handle_t *handle, struct in=
ode *inode,
 	__le32 border;
 	ext4_fsblk_t *ablocks =3D NULL; /* array of allocated blocks */
 	int err =3D 0;
+	size_t ext_size =3D 0;
=20
 	/* make decision: where to split? */
 	/* FIXME: now decision is simplest: at current extent */
@@ -1107,6 +1108,10 @@ static int ext4_ext_split(handle_t *handle, struct i=
node *inode,
 		le16_add_cpu(&neh->eh_entries, m);
 	}
=20
+	/* zero out unused area in the extent block */
+	ext_size =3D sizeof(struct ext4_extent_header) +
+		sizeof(struct ext4_extent) * le16_to_cpu(neh->eh_entries);
+	memset(bh->b_data + ext_size, 0, inode->i_sb->s_blocksize - ext_size);
 	ext4_extent_block_csum_set(inode, neh);
 	set_buffer_uptodate(bh);
 	unlock_buffer(bh);
@@ -1186,6 +1191,11 @@ static int ext4_ext_split(handle_t *handle, struct i=
node *inode,
 				sizeof(struct ext4_extent_idx) * m);
 			le16_add_cpu(&neh->eh_entries, m);
 		}
+		/* zero out unused area in the extent block */
+		ext_size =3D sizeof(struct ext4_extent_header) +
+		   (sizeof(struct ext4_extent) * le16_to_cpu(neh->eh_entries));
+		memset(bh->b_data + ext_size, 0,
+			inode->i_sb->s_blocksize - ext_size);
 		ext4_extent_block_csum_set(inode, neh);
 		set_buffer_uptodate(bh);
 		unlock_buffer(bh);
@@ -1251,6 +1261,7 @@ static int ext4_ext_grow_indepth(handle_t *handle, st=
ruct inode *inode,
 	struct buffer_head *bh;
 	ext4_fsblk_t newblock;
 	int err =3D 0;
+	size_t ext_size =3D 0;
=20
 	newblock =3D ext4_ext_new_meta_block(handle, inode, NULL,
 		newext, &err, flags);
@@ -1268,9 +1279,11 @@ static int ext4_ext_grow_indepth(handle_t *handle, s=
truct inode *inode,
 		goto out;
 	}
=20
+	ext_size =3D sizeof(EXT4_I(inode)->i_data);
 	/* move top-level index/leaf into new block */
-	memmove(bh->b_data, EXT4_I(inode)->i_data,
-		sizeof(EXT4_I(inode)->i_data));
+	memmove(bh->b_data, EXT4_I(inode)->i_data, ext_size);
+	/* zero out unused area in the extent block */
+	memset(bh->b_data + ext_size, 0, inode->i_sb->s_blocksize - ext_size);
=20
 	/* set size of new block */
 	neh =3D ext_block_hdr(bh);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 42a3552f641a..a576467cd4a5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1241,6 +1241,11 @@ int get_cmdline(struct task_struct *task, char *buff=
er, int buflen);
=20
 int vma_is_stack_for_task(struct vm_area_struct *vma, struct task_struct *=
t);
=20
+static inline bool vma_is_anonymous(struct vm_area_struct *vma)
+{
+	return !vma->vm_ops;
+}
+
 extern unsigned long move_page_tables(struct vm_area_struct *vma,
 		unsigned long old_addr, struct vm_area_struct *new_vma,
 		unsigned long new_addr, unsigned long len,
diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index d7da0cf3332b..b34cbad45f14 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -394,4 +394,7 @@ static inline int fastopen_init_queue(struct sock *sk, =
int backlog)
 	return 0;
 }
=20
+int tcp_skb_shift(struct sk_buff *to, struct sk_buff *from, int pcount,
+		  int shiftlen);
+
 #endif	/* _LINUX_TCP_H */
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 6f404e98876a..79762b662de3 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -55,6 +55,8 @@ void tcp_time_wait(struct sock *sk, int state, int timeo)=
;
=20
 #define MAX_TCP_HEADER	(128 + MAX_HEADER)
 #define MAX_TCP_OPTION_SPACE 40
+#define TCP_MIN_SND_MSS		48
+#define TCP_MIN_GSO_SIZE	(TCP_MIN_SND_MSS - MAX_TCP_OPTION_SPACE)
=20
 /*=20
  * Never offer a window over 32767 without using window scaling. Some
@@ -268,6 +270,7 @@ extern int sysctl_tcp_moderate_rcvbuf;
 extern int sysctl_tcp_tso_win_divisor;
 extern int sysctl_tcp_mtu_probing;
 extern int sysctl_tcp_base_mss;
+extern int sysctl_tcp_min_snd_mss;
 extern int sysctl_tcp_workaround_signed_windows;
 extern int sysctl_tcp_slow_start_after_idle;
 extern int sysctl_tcp_thin_linear_timeouts;
diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index df40137f33dd..baa4995806d3 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -265,6 +265,7 @@ enum
 	LINUX_MIB_TCPWANTZEROWINDOWADV,		/* TCPWantZeroWindowAdv */
 	LINUX_MIB_TCPSYNRETRANS,		/* TCPSynRetrans */
 	LINUX_MIB_TCPORIGDATASENT,		/* TCPOrigDataSent */
+	LINUX_MIB_TCPWQUEUETOOBIG,		/* TCPWqueueTooBig */
 	__LINUX_MIB_MAX
 };
=20
diff --git a/mm/memory.c b/mm/memory.c
index 62c2c8a148b0..1de5302d5738 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3105,12 +3105,12 @@ static int handle_pte_fault(struct mm_struct *mm,
 	entry =3D *pte;
 	if (!pte_present(entry)) {
 		if (pte_none(entry)) {
-			if (vma->vm_ops)
+			if (vma_is_anonymous(vma))
+				return do_anonymous_page(mm, vma, address,
+							 pte, pmd, flags);
+			else
 				return do_fault(mm, vma, address, pte,
 						pmd, flags, entry);
-
-			return do_anonymous_page(mm, vma, address,
-						 pte, pmd, flags);
 		}
 		return do_swap_page(mm, vma, address,
 					pte, pmd, flags, entry);
diff --git a/mm/mincore.c b/mm/mincore.c
index 3c4c8f6ab57e..1d802326abab 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -212,6 +212,22 @@ static void mincore_page_range(struct vm_area_struct *=
vma,
 	} while (pgd++, addr =3D next, addr !=3D end);
 }
=20
+static inline bool can_do_mincore(struct vm_area_struct *vma)
+{
+	if (vma_is_anonymous(vma))
+		return true;
+	if (!vma->vm_file)
+		return false;
+	/*
+	 * Reveal pagecache information only for non-anonymous mappings that
+	 * correspond to the files the calling process could (if tried) open
+	 * for writing; otherwise we'd be including shared non-exclusive
+	 * mappings, which opens a side channel.
+	 */
+	return inode_owner_or_capable(file_inode(vma->vm_file)) ||
+		inode_permission(file_inode(vma->vm_file), MAY_WRITE) =3D=3D 0;
+}
+
 /*
  * Do a chunk of "sys_mincore()". We've already checked
  * all the arguments, we hold the mmap semaphore: we should
@@ -227,6 +243,11 @@ static long do_mincore(unsigned long addr, unsigned lo=
ng pages, unsigned char *v
 		return -ENOMEM;
=20
 	end =3D min(vma->vm_end, addr + (pages << PAGE_SHIFT));
+	if (!can_do_mincore(vma)) {
+		unsigned long pages =3D DIV_ROUND_UP(end - addr, PAGE_SIZE);
+		memset(vec, 1, pages);
+		return pages;
+	}
=20
 	if (is_vm_hugetlb_page(vma))
 		mincore_hugetlb_page_range(vma, addr, end, vec);
diff --git a/net/bluetooth/hidp/sock.c b/net/bluetooth/hidp/sock.c
index cb3fdde1968a..322047f9d038 100644
--- a/net/bluetooth/hidp/sock.c
+++ b/net/bluetooth/hidp/sock.c
@@ -76,6 +76,7 @@ static int hidp_sock_ioctl(struct socket *sock, unsigned =
int cmd, unsigned long
 			sockfd_put(csock);
 			return err;
 		}
+		ca.name[sizeof(ca.name)-1] =3D 0;
=20
 		err =3D hidp_connection_add(&ca, csock, isock);
 		if (!err && copy_to_user(argp, &ca, sizeof(ca)))
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index ae0af9386f7c..14da5171772d 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -286,6 +286,7 @@ static const struct snmp_mib snmp4_net_list[] =3D {
 	SNMP_MIB_ITEM("TCPWantZeroWindowAdv", LINUX_MIB_TCPWANTZEROWINDOWADV),
 	SNMP_MIB_ITEM("TCPSynRetrans", LINUX_MIB_TCPSYNRETRANS),
 	SNMP_MIB_ITEM("TCPOrigDataSent", LINUX_MIB_TCPORIGDATASENT),
+	SNMP_MIB_ITEM("TCPWqueueTooBig", LINUX_MIB_TCPWQUEUETOOBIG),
 	SNMP_MIB_SENTINEL
 };
=20
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index e1ceafe68cb1..fbbb89c0334a 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -34,6 +34,8 @@ static int tcp_retr1_max =3D 255;
 static int ip_local_port_range_min[] =3D { 1, 1 };
 static int ip_local_port_range_max[] =3D { 65535, 65535 };
 static int tcp_adv_win_scale_min =3D -31;
+static int tcp_min_snd_mss_min =3D TCP_MIN_SND_MSS;
+static int tcp_min_snd_mss_max =3D 65535;
 static int tcp_adv_win_scale_max =3D 31;
 static int ip_ttl_min =3D 1;
 static int ip_ttl_max =3D 255;
@@ -607,6 +609,15 @@ static struct ctl_table ipv4_table[] =3D {
 		.mode		=3D 0644,
 		.proc_handler	=3D proc_dointvec,
 	},
+	{
+		.procname	=3D "tcp_min_snd_mss",
+		.data		=3D &sysctl_tcp_min_snd_mss,
+		.maxlen		=3D sizeof(int),
+		.mode		=3D 0644,
+		.proc_handler	=3D proc_dointvec_minmax,
+		.extra1		=3D &tcp_min_snd_mss_min,
+		.extra2		=3D &tcp_min_snd_mss_max,
+	},
 	{
 		.procname	=3D "tcp_workaround_signed_windows",
 		.data		=3D &sysctl_tcp_workaround_signed_windows,
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 5fc281b60515..e16ae4249199 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3169,6 +3169,7 @@ void __init tcp_init(void)
 	int max_rshare, max_wshare, cnt;
 	unsigned int i;
=20
+	BUILD_BUG_ON(TCP_MIN_SND_MSS <=3D MAX_TCP_OPTION_SPACE);
 	BUILD_BUG_ON(sizeof(struct tcp_skb_cb) > sizeof(skb->cb));
=20
 	percpu_counter_init(&tcp_sockets_allocated, 0);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 00ffa3d3bcae..e605b1fd116b 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1296,7 +1296,7 @@ static bool tcp_shifted_skb(struct sock *sk, struct s=
k_buff *skb,
 	TCP_SKB_CB(skb)->seq +=3D shifted;
=20
 	skb_shinfo(prev)->gso_segs +=3D pcount;
-	BUG_ON(skb_shinfo(skb)->gso_segs < pcount);
+	WARN_ON_ONCE(tcp_skb_pcount(skb) < pcount);
 	skb_shinfo(skb)->gso_segs -=3D pcount;
=20
 	/* When we're adding to gso_segs =3D=3D 1, gso_size will be zero,
@@ -1362,6 +1362,21 @@ static int skb_can_shift(const struct sk_buff *skb)
 	return !skb_headlen(skb) && skb_is_nonlinear(skb);
 }
=20
+int tcp_skb_shift(struct sk_buff *to, struct sk_buff *from,
+		  int pcount, int shiftlen)
+{
+	/* TCP min gso_size is 8 bytes (TCP_MIN_GSO_SIZE)
+	 * Since TCP_SKB_CB(skb)->tcp_gso_segs is 16 bits, we need
+	 * to make sure not storing more than 65535 * 8 bytes per skb,
+	 * even if current MSS is bigger.
+	 */
+	if (unlikely(to->len + shiftlen >=3D 65535 * TCP_MIN_GSO_SIZE))
+		return 0;
+	if (unlikely(tcp_skb_pcount(to) + pcount > 65535))
+		return 0;
+	return skb_shift(to, from, shiftlen);
+}
+
 /* Try collapsing SACK blocks spanning across multiple skbs to a single
  * skb.
  */
@@ -1373,6 +1388,7 @@ static struct sk_buff *tcp_shift_skb_data(struct sock=
 *sk, struct sk_buff *skb,
 	struct tcp_sock *tp =3D tcp_sk(sk);
 	struct sk_buff *prev;
 	int mss;
+	int next_pcount;
 	int pcount =3D 0;
 	int len;
 	int in_sack;
@@ -1467,7 +1483,7 @@ static struct sk_buff *tcp_shift_skb_data(struct sock=
 *sk, struct sk_buff *skb,
 	if (!after(TCP_SKB_CB(skb)->seq + len, tp->snd_una))
 		goto fallback;
=20
-	if (!skb_shift(prev, skb, len))
+	if (!tcp_skb_shift(prev, skb, pcount, len))
 		goto fallback;
 	if (!tcp_shifted_skb(sk, skb, state, pcount, len, mss, dup_sack))
 		goto out;
@@ -1486,9 +1502,10 @@ static struct sk_buff *tcp_shift_skb_data(struct soc=
k *sk, struct sk_buff *skb,
 		goto out;
=20
 	len =3D skb->len;
-	if (skb_shift(prev, skb, len)) {
-		pcount +=3D tcp_skb_pcount(skb);
-		tcp_shifted_skb(sk, skb, state, tcp_skb_pcount(skb), len, mss, 0);
+	next_pcount =3D tcp_skb_pcount(skb);
+	if (tcp_skb_shift(prev, skb, next_pcount, len)) {
+		pcount +=3D next_pcount;
+		tcp_shifted_skb(sk, skb, state, next_pcount, len, mss, 0);
 	}
=20
 out:
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 0d7ed41b40be..4a64bebd360d 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -61,6 +61,7 @@ int sysctl_tcp_tso_win_divisor __read_mostly =3D 3;
=20
 int sysctl_tcp_mtu_probing __read_mostly =3D 0;
 int sysctl_tcp_base_mss __read_mostly =3D TCP_BASE_MSS;
+int sysctl_tcp_min_snd_mss __read_mostly =3D TCP_MIN_SND_MSS;
=20
 /* By default, RFC2861 behavior.  */
 int sysctl_tcp_slow_start_after_idle __read_mostly =3D 1;
@@ -1090,6 +1091,11 @@ int tcp_fragment(struct sock *sk, struct sk_buff *sk=
b, u32 len,
 	if (nsize < 0)
 		nsize =3D 0;
=20
+	if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf)) {
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPWQUEUETOOBIG);
+		return -ENOMEM;
+	}
+
 	if (skb_unclone(skb, gfp))
 		return -ENOMEM;
=20
@@ -1254,8 +1260,7 @@ static inline int __tcp_mtu_to_mss(struct sock *sk, i=
nt pmtu)
 	mss_now -=3D icsk->icsk_ext_hdr_len;
=20
 	/* Then reserve room for full set of TCP options and 8 bytes of data */
-	if (mss_now < 48)
-		mss_now =3D 48;
+	mss_now =3D max(mss_now, sysctl_tcp_min_snd_mss);
 	return mss_now;
 }
=20
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 286227abed10..a7b930fd6110 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -113,6 +113,7 @@ static void tcp_mtu_probing(struct inet_connection_sock=
 *icsk, struct sock *sk)
 			mss =3D tcp_mtu_to_mss(sk, icsk->icsk_mtup.search_low) >> 1;
 			mss =3D min(sysctl_tcp_base_mss, mss);
 			mss =3D max(mss, 68 - tp->tcp_header_len);
+			mss =3D max(mss, sysctl_tcp_min_snd_mss);
 			icsk->icsk_mtup.search_low =3D tcp_mss_to_mtu(sk, mss);
 			tcp_sync_mss(sk, icsk->icsk_pmtu_cookie);
 		}
=0D
--=-TCiGxj4hJ2DGJI8Kw6Tn--

--=-0TO52R/JStVqR/4csUtx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl0LzKEACgkQ57/I7JWG
EQmU8Q/9GYfWaEwysbCSuoRsolIC5kbH5dxHnVGBUXhD8U/yCvX5ZKQ3cMsMNSYz
SplsrnCiSHBlNomCBVzcqwCJsvhvq4+i9v6JAekWN3VY3g3Y2cJ45OjQ0qmXS6bh
FRXrnfO6SGW+yyxdaFK5pP38+IDmTlQ9fMYK7midv+0ICNEQBtnooUc9Y5Czsvlu
OzFFxoygrXLV7ZVoJLtL392HT0AeE8HgKbPIzdEJZ8i0EYkPmOCYf45fwDWycdEC
Xvm7tE0X3MG0UNFYTvlbTgLlPGwMj8FY9SNCdbGhL9OFMPInEXAS4W5w/32xQNlZ
IwhdE+31YDjsngCPgSAld86OOrCF46PQcFrWbEGX+fNQiaHwF4/vG3h7m7saFOcr
8cETzPxQxYjfTX7e6GPbYQdIIObiJU4UHgyFCQqzZ16jdQ/wfY0DYxblaMC+PZCO
quzapVCx0KpWVz5fByMvPScvwnKgol4N9pF2SspKJJOVRePauTANHXjW//QRMyaI
W7K7I78HHDTeQBMAnMmIqWke2ymXRErRWUHQa2TBfF9GAoHZ9YV5lbw6T4GcD7mn
ZwQ1onuWol8+vrHRcUjL16DihcA53d5SGGBM7c+LAbu9J5JGXmAuskQMCTj2iYlD
+C21dECxbo9TUqseXe93bjVnbB8MMJZ+fRwhH7j7nUN3r9YNHyw=
=StNm
-----END PGP SIGNATURE-----

--=-0TO52R/JStVqR/4csUtx--
