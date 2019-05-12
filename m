Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04F311AC0C
	for <lists+stable@lfdr.de>; Sun, 12 May 2019 14:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbfELM3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 May 2019 08:29:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41404 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726100AbfELM3X (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 May 2019 08:29:23 -0400
Received: from ben by shadbolt.decadent.org.uk with local (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hPnbS-0007g2-Py; Sun, 12 May 2019 13:29:19 +0100
Date:   Sun, 12 May 2019 13:29:18 +0100
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc:     lwn@lwn.net
Message-ID: <lsq.1557584591.907202651@decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4tpcqvroypui2sxe"
Content-Disposition: inline
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on
        shadbolt.decadent.org.uk
X-Spam-Level: 
X-Spam-Status: No, score=-0.0 required=5.0 tests=NO_RELAYS autolearn=disabled
        version=3.4.2
Subject: Linux 3.16.67
X-SA-Exim-Version: 4.2.1 (built Tue, 02 Aug 2016 21:08:31 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--4tpcqvroypui2sxe
Content-Type: multipart/mixed; boundary="tv5wc5lwkljev3m7"
Content-Disposition: inline


--tv5wc5lwkljev3m7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.16.67 kernel.

All users of the 3.16 kernel series should upgrade.

The updated 3.16.y git tree can be found at:
        https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.16.y
and can be browsed at the normal kernel.org git web browser:
        https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git

The diff from 3.16.66 is attached to this message.

Ben.

------------

 Makefile                                              |  2 +-
 arch/x86/kvm/vmx.c                                    |  4 +++-
 drivers/net/vxlan.c                                   |  2 +-
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c | 16 +++++++++++-----
 drivers/spi/spi-omap-100k.c                           |  4 ----
 include/net/ip_fib.h                                  |  2 +-
 kernel/fork.c                                         | 15 ++++++++++++---
 kernel/time/timer_stats.c                             |  2 +-
 mm/percpu.c                                           |  8 ++++----
 net/ipv4/fib_semantics.c                              |  8 +++++---
 net/ipv4/route.c                                      | 10 ++++++----
 net/ipv6/ip6_output.c                                 |  3 +++
 12 files changed, 48 insertions(+), 28 deletions(-)

Amit Klein (1):
      inet: update the IP ID generation algorithm to higher standards.

Arend Van Spriel (1):
      brcmfmac: add length checks in scheduled scan result handler

Ben Hutchings (4):
      Revert "brcmfmac: assure SSID length from firmware is limited"
      vxlan: Fix big-endian declaration of VNI
      timer/debug: Change /proc/timer_stats from 0644 to 0600
      Linux 3.16.67

David Herrmann (1):
      fork: record start_time late

Eric Dumazet (1):
      ipv4: fix a race in update_or_create_fnhe()

Joerg Roedel (1):
      KVM: VMX: Fix x2apic check in vmx_msr_bitmap_mode()

Matteo Croce (1):
      percpu: stop printing kernel addresses

Nick Krause (1):
      spi: omap-100k: Remove unused definitions


--tv5wc5lwkljev3m7
Content-Type: text/x-diff; charset=UTF-8; name="linux-3.16.67.patch"
Content-Disposition: attachment; filename="linux-3.16.67.patch"
Content-Transfer-Encoding: quoted-printable

diff --git a/Makefile b/Makefile
index 7387b85870f2..33a54d0451a3 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION =3D 3
 PATCHLEVEL =3D 16
-SUBLEVEL =3D 66
+SUBLEVEL =3D 67
 EXTRAVERSION =3D
 NAME =3D Museum of Fishiegoodies
=20
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index bc3dc38fa486..bd6b883f3075 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4224,7 +4224,9 @@ static u8 vmx_msr_bitmap_mode(struct kvm_vcpu *vcpu)
 {
 	u8 mode =3D 0;
=20
-	if (irqchip_in_kernel(vcpu->kvm) && apic_x2apic_mode(vcpu->arch.apic)) {
+	if (cpu_has_secondary_exec_ctrls() &&
+	    (vmcs_read32(SECONDARY_VM_EXEC_CONTROL) &
+	     SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE)) {
 		mode |=3D MSR_BITMAP_MODE_X2APIC;
 		if (enable_apicv)
 			mode |=3D MSR_BITMAP_MODE_X2APIC_APICV;
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 31abf2e7b199..d7e4f83f8bf3 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -706,7 +706,7 @@ static struct vxlan_fdb *vxlan_fdb_alloc(struct vxlan_d=
ev *vxlan,
 static int vxlan_fdb_create(struct vxlan_dev *vxlan,
 			    const u8 *mac, union vxlan_addr *ip,
 			    __u16 state, __be16 port,
-			    __be32 vni, __u32 ifindex, __u8 ndm_flags,
+			    __u32 vni, __u32 ifindex, __u8 ndm_flags,
 			    struct vxlan_fdb **fdb)
 {
 	struct vxlan_rdst *rd =3D NULL;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/driver=
s/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index e6e2c5afec06..1a0a62219eed 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3033,6 +3033,7 @@ brcmf_notify_sched_scan_results(struct brcmf_if *ifp,
 	struct brcmf_pno_scanresults_le *pfn_result;
 	u32 result_count;
 	u32 status;
+	u32 datalen;
=20
 	brcmf_dbg(SCAN, "Enter\n");
=20
@@ -3059,6 +3060,14 @@ brcmf_notify_sched_scan_results(struct brcmf_if *ifp,
 	if (result_count > 0) {
 		int i;
=20
+		data +=3D sizeof(struct brcmf_pno_scanresults_le);
+		netinfo_start =3D (struct brcmf_pno_net_info_le *)data;
+		datalen =3D e->datalen - ((void *)netinfo_start - (void *)pfn_result);
+		if (datalen < result_count * sizeof(*netinfo)) {
+			brcmf_err("insufficient event data\n");
+			goto out_err;
+		}
+
 		request =3D kzalloc(sizeof(*request), GFP_KERNEL);
 		ssid =3D kcalloc(result_count, sizeof(*ssid), GFP_KERNEL);
 		channel =3D kcalloc(result_count, sizeof(*channel), GFP_KERNEL);
@@ -3068,9 +3077,6 @@ brcmf_notify_sched_scan_results(struct brcmf_if *ifp,
 		}
=20
 		request->wiphy =3D wiphy;
-		data +=3D sizeof(struct brcmf_pno_scanresults_le);
-		netinfo_start =3D (struct brcmf_pno_net_info_le *)data;
-
 		for (i =3D 0; i < result_count; i++) {
 			netinfo =3D &netinfo_start[i];
 			if (!netinfo) {
@@ -3080,10 +3086,10 @@ brcmf_notify_sched_scan_results(struct brcmf_if *if=
p,
 				goto out_err;
 			}
=20
-			brcmf_dbg(SCAN, "SSID:%s Channel:%d\n",
-				  netinfo->SSID, netinfo->channel);
 			if (netinfo->SSID_len > IEEE80211_MAX_SSID_LEN)
 				netinfo->SSID_len =3D IEEE80211_MAX_SSID_LEN;
+			brcmf_dbg(SCAN, "SSID:%s Channel:%d\n",
+				  netinfo->SSID, netinfo->channel);
 			memcpy(ssid[i].ssid, netinfo->SSID, netinfo->SSID_len);
 			ssid[i].ssid_len =3D netinfo->SSID_len;
 			request->n_ssids++;
diff --git a/drivers/spi/spi-omap-100k.c b/drivers/spi/spi-omap-100k.c
index e7ffcded4e14..75a5b1913807 100644
--- a/drivers/spi/spi-omap-100k.c
+++ b/drivers/spi/spi-omap-100k.c
@@ -70,10 +70,6 @@
 #define SPI_STATUS_WE                   (1UL << 1)
 #define SPI_STATUS_RD                   (1UL << 0)
=20
-#define WRITE 0
-#define READ  1
-
-
 /* use PIO for small transfers, avoiding DMA setup/teardown overhead and
  * cache operations; better heuristics consider wordsize and bitrate.
  */
diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 68d6df7bc85a..928bf612f6ff 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -89,7 +89,7 @@ struct fib_nh {
 	int			nh_saddr_genid;
 	struct rtable __rcu * __percpu *nh_pcpu_rth_output;
 	struct rtable __rcu	*nh_rth_input;
-	struct fnhe_hash_bucket	*nh_exceptions;
+	struct fnhe_hash_bucket	__rcu *nh_exceptions;
 };
=20
 /*
diff --git a/kernel/fork.c b/kernel/fork.c
index 27f6a67f692e..7dc86b50f925 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1265,9 +1265,6 @@ static struct task_struct *copy_process(unsigned long=
 clone_flags,
=20
 	posix_cpu_timers_init(p);
=20
-	do_posix_clock_monotonic_gettime(&p->start_time);
-	p->real_start_time =3D p->start_time;
-	monotonic_to_bootbased(&p->real_start_time);
 	p->io_context =3D NULL;
 	p->audit_context =3D NULL;
 	if (clone_flags & CLONE_THREAD)
@@ -1422,6 +1419,18 @@ static struct task_struct *copy_process(unsigned lon=
g clone_flags,
 	INIT_LIST_HEAD(&p->thread_group);
 	p->task_works =3D NULL;
=20
+	/*
+	 * From this point on we must avoid any synchronous user-space
+	 * communication until we take the tasklist-lock. In particular, we do
+	 * not want user-space to be able to predict the process start-time by
+	 * stalling fork(2) after we recorded the start_time but before it is
+	 * visible to the system.
+	 */
+
+	do_posix_clock_monotonic_gettime(&p->start_time);
+	p->real_start_time =3D p->start_time;
+	monotonic_to_bootbased(&p->real_start_time);
+
 	/*
 	 * Make it visible to the rest of the system, but dont wake it up yet.
 	 * Need tasklist lock for parent etc handling!
diff --git a/kernel/time/timer_stats.c b/kernel/time/timer_stats.c
index 1fb08f21302e..0334899f1d3e 100644
--- a/kernel/time/timer_stats.c
+++ b/kernel/time/timer_stats.c
@@ -417,7 +417,7 @@ static int __init init_tstats_procfs(void)
 {
 	struct proc_dir_entry *pe;
=20
-	pe =3D proc_create("timer_stats", 0644, NULL, &tstats_fops);
+	pe =3D proc_create("timer_stats", 0600, NULL, &tstats_fops);
 	if (!pe)
 		return -ENOMEM;
 	return 0;
diff --git a/mm/percpu.c b/mm/percpu.c
index 2ddf9a990dbd..7fae38984a21 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1716,8 +1716,8 @@ int __init pcpu_embed_first_chunk(size_t reserved_siz=
e, size_t dyn_size,
 #endif
 	}
=20
-	pr_info("PERCPU: Embedded %zu pages/cpu @%p s%zu r%zu d%zu u%zu\n",
-		PFN_DOWN(size_sum), base, ai->static_size, ai->reserved_size,
+	pr_info("PERCPU: Embedded %zu pages/cpu s%zu r%zu d%zu u%zu\n",
+		PFN_DOWN(size_sum), ai->static_size, ai->reserved_size,
 		ai->dyn_size, ai->unit_size);
=20
 	rc =3D pcpu_setup_first_chunk(ai, base);
@@ -1830,8 +1830,8 @@ int __init pcpu_page_first_chunk(size_t reserved_size,
 	}
=20
 	/* we're ready, commit */
-	pr_info("PERCPU: %d %s pages/cpu @%p s%zu r%zu d%zu\n",
-		unit_pages, psize_str, vm.addr, ai->static_size,
+	pr_info("PERCPU: %d %s pages/cpu s%zu r%zu d%zu\n",
+		unit_pages, psize_str, ai->static_size,
 		ai->reserved_size, ai->dyn_size);
=20
 	rc =3D pcpu_setup_first_chunk(ai, vm.addr);
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 6f44569623ae..83656bdb00e2 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -157,9 +157,12 @@ static void rt_fibinfo_free(struct rtable __rcu **rtp)
=20
 static void free_nh_exceptions(struct fib_nh *nh)
 {
-	struct fnhe_hash_bucket *hash =3D nh->nh_exceptions;
+	struct fnhe_hash_bucket *hash;
 	int i;
=20
+	hash =3D rcu_dereference_protected(nh->nh_exceptions, 1);
+	if (!hash)
+		return;
 	for (i =3D 0; i < FNHE_HASH_SIZE; i++) {
 		struct fib_nh_exception *fnhe;
=20
@@ -206,8 +209,7 @@ static void free_fib_info_rcu(struct rcu_head *head)
 	change_nexthops(fi) {
 		if (nexthop_nh->nh_dev)
 			dev_put(nexthop_nh->nh_dev);
-		if (nexthop_nh->nh_exceptions)
-			free_nh_exceptions(nexthop_nh);
+		free_nh_exceptions(nexthop_nh);
 		rt_fibinfo_free_cpus(nexthop_nh->nh_pcpu_rth_output);
 		rt_fibinfo_free(&nexthop_nh->nh_rth_input);
 	} endfor_nexthops(fi);
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 4f7c378c841d..e0d59ff394b2 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -487,13 +487,15 @@ EXPORT_SYMBOL(ip_idents_reserve);
 void __ip_select_ident(struct iphdr *iph, int segs)
 {
 	static u32 ip_idents_hashrnd __read_mostly;
+	static u32 ip_idents_hashrnd_extra __read_mostly;
 	u32 hash, id;
=20
 	net_get_random_once(&ip_idents_hashrnd, sizeof(ip_idents_hashrnd));
+	net_get_random_once(&ip_idents_hashrnd_extra, sizeof(ip_idents_hashrnd_ex=
tra));
=20
 	hash =3D jhash_3words((__force u32)iph->daddr,
 			    (__force u32)iph->saddr,
-			    iph->protocol,
+			    iph->protocol ^ ip_idents_hashrnd_extra,
 			    ip_idents_hashrnd);
 	id =3D ip_idents_reserve(hash, segs);
 	iph->id =3D htons(id);
@@ -633,12 +635,12 @@ static void update_or_create_fnhe(struct fib_nh *nh, =
__be32 daddr, __be32 gw,
=20
 	spin_lock_bh(&fnhe_lock);
=20
-	hash =3D nh->nh_exceptions;
+	hash =3D rcu_dereference(nh->nh_exceptions);
 	if (!hash) {
 		hash =3D kzalloc(FNHE_HASH_SIZE * sizeof(*hash), GFP_ATOMIC);
 		if (!hash)
 			goto out_unlock;
-		nh->nh_exceptions =3D hash;
+		rcu_assign_pointer(nh->nh_exceptions, hash);
 	}
=20
 	hash +=3D hval;
@@ -1291,7 +1293,7 @@ static void ip_del_fnhe(struct fib_nh *nh, __be32 dad=
dr)
=20
 static struct fib_nh_exception *find_exception(struct fib_nh *nh, __be32 d=
addr)
 {
-	struct fnhe_hash_bucket *hash =3D nh->nh_exceptions;
+	struct fnhe_hash_bucket *hash =3D rcu_dereference(nh->nh_exceptions);
 	struct fib_nh_exception *fnhe;
 	u32 hval;
=20
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index e59b30054b0f..bb98cde51476 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -541,12 +541,15 @@ static void ip6_copy_metadata(struct sk_buff *to, str=
uct sk_buff *from)
 static void ipv6_select_ident(struct frag_hdr *fhdr, struct rt6_info *rt)
 {
 	static u32 ip6_idents_hashrnd __read_mostly;
+	static u32 ip6_idents_hashrnd_extra __read_mostly;
 	u32 hash, id;
=20
 	net_get_random_once(&ip6_idents_hashrnd, sizeof(ip6_idents_hashrnd));
+	net_get_random_once(&ip6_idents_hashrnd_extra, sizeof(ip6_idents_hashrnd_=
extra));
=20
 	hash =3D __ipv6_addr_jhash(&rt->rt6i_dst.addr, ip6_idents_hashrnd);
 	hash =3D __ipv6_addr_jhash(&rt->rt6i_src.addr, hash);
+	hash =3D jhash_1word(hash, ip6_idents_hashrnd_extra);
=20
 	id =3D ip_idents_reserve(hash, 1);
 	fhdr->identification =3D htonl(id);

--tv5wc5lwkljev3m7--

--4tpcqvroypui2sxe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAlzYEZkACgkQ57/I7JWG
EQlvOQ//fLBUYaSQe/EtnuQwQlylcDs3XpQ7wBMx6JWaVRW4JJMIs08W63lt0yeX
VKQKeRbaQihwJIYjs5asHbP1mBscFgPHk9GptzcZmkaL3LyyTpqyvNMtu4U76mAj
RP6LPa+Hvq1nElmyIJqHMANRtCqg2ogVU+SiSUI07Atwn0ofFfTXLPPxdI5nF8X9
qMrldSoXpCgktnhmgd5Sa2nPtAtQdxu8st5MFWlOWkKcpENAFofDERIH7RmJqu8K
4DixoV33BHxUVCAGGaZ+PiQArLIvLs3EaAaQQ6aeB53fmTck/qASxIOXdQTuf+4V
WqGt42qZn/akjpenBeUIIMORvW2OcAsw3vq0YemgqnUCnz/55upGMqlJrDkiR16k
txB61oMEyjyNqNVO0HzRitysPR4Rj/ckkyh5ftswCWbESLBbe0vV6M7rI1g+stJz
42vTH1dy5P1x8imUcGJ3MLHAPosHU2TO753R70w4hUry1yveHvyNFvsr5RUGsEk/
X9uVksSDc6TNX89hr7796Fa4+YmCGisTHDwD0Ip/7p3ITJiGAP5bvSd8OREUlEMr
6APUQzgWHZ/OmeEtoOeTu6qwDo53V3bHZF3zyFykbajlylBHp/vEXpUAz/5+t6nu
Cp94sAZQppJCQezokOQ7Lf5h/6MzgrgJJeiBuygJKkHzcri+5So=
=HRtF
-----END PGP SIGNATURE-----

--4tpcqvroypui2sxe--
