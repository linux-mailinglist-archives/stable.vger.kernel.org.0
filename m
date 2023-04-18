Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 846F46E6700
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 16:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbjDROVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 10:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbjDROVC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 10:21:02 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941659C;
        Tue, 18 Apr 2023 07:21:00 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3F5461F8D4;
        Tue, 18 Apr 2023 14:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1681827659; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=msQfS+TSBvcJPSLbCbcdaZBhz2r4XoDvKXFYtrjO0cg=;
        b=c5BhSCuHQ1OZB69jROiqYxnukOlvdbG7MJMlcpWaXpaxPNoUatL7ZmQ/jlNsXlUl7VgmGp
        V4gY9iTwA+gJRe1dVkvCr7OxhuLK8EvAlH54m2p8lQBzd7xAi/Sv2CtUIZcSbA+msbuZqu
        kOzbpaJvd00BFWYj2FZcWwRe+f3x76k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1681827659;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=msQfS+TSBvcJPSLbCbcdaZBhz2r4XoDvKXFYtrjO0cg=;
        b=TRAhHlQ1Eh+L1yFTxFOJzeT/fhsC+xIiNvUn700L2oNubeQyOOsrZ0R+Ap9voD+sHBy93Q
        iCAvNYi/HdyXd3DA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B7A3A13581;
        Tue, 18 Apr 2023 14:20:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id yKffKUqnPmQYWAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Tue, 18 Apr 2023 14:20:58 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id f9a92aa2;
        Tue, 18 Apr 2023 14:20:57 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH v3] ceph: fix potential use-after-free bug when trimming
 caps
References: <20230418014506.95428-1-xiubli@redhat.com>
Date:   Tue, 18 Apr 2023 15:20:57 +0100
In-Reply-To: <20230418014506.95428-1-xiubli@redhat.com> (xiubli@redhat.com's
        message of "Tue, 18 Apr 2023 09:45:06 +0800")
Message-ID: <877cu9w9ti.fsf@brahms.olymp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

xiubli@redhat.com writes:

> From: Xiubo Li <xiubli@redhat.com>
>
> When trimming the caps and just after the 'session->s_cap_lock' is
> released in ceph_iterate_session_caps() the cap maybe removed by
> another thread, and when using the stale cap memory in the callbacks
> it will trigger use-after-free crash.
>
> We need to check the existence of the cap just after the 'ci->i_ceph_lock'
> being acquired. And do nothing if it's already removed.

Your patch seems to be OK, but I'll be honest: the locking is *so* complex
that I can say for sure it really solves any problem :-(

ceph_put_cap() uses mdsc->caps_list_lock to protect the list, but I can't
be sure that holding ci->i_ceph_lock will protect a race in the case
you're trying to solve.

Is the issue in that bugzilla reproducible, or was that a one-time thing?

Cheers,
--=20
Lu=C3=ADs


> Cc: stable@vger.kernel.org
> URL: https://bugzilla.redhat.com/show_bug.cgi?id=3D2186264
> URL: https://tracker.ceph.com/issues/43272
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>
> V3:
> - Fixed 3 issues, which reported by Luis and kernel test robot <lkp@intel=
.com>
>
>  fs/ceph/debugfs.c    |  7 ++++-
>  fs/ceph/mds_client.c | 68 +++++++++++++++++++++++++++++---------------
>  fs/ceph/mds_client.h |  2 +-
>  3 files changed, 52 insertions(+), 25 deletions(-)
>
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index bec3c4549c07..5c0f07df5b02 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -248,14 +248,19 @@ static int metrics_caps_show(struct seq_file *s, vo=
id *p)
>  	return 0;
>  }
>=20=20
> -static int caps_show_cb(struct inode *inode, struct ceph_cap *cap, void =
*p)
> +static int caps_show_cb(struct inode *inode, struct rb_node *ci_node, vo=
id *p)
>  {
> +	struct ceph_inode_info *ci =3D ceph_inode(inode);
>  	struct seq_file *s =3D p;
> +	struct ceph_cap *cap;
>=20=20
> +	spin_lock(&ci->i_ceph_lock);
> +	cap =3D rb_entry(ci_node, struct ceph_cap, ci_node);
>  	seq_printf(s, "0x%-17llx%-3d%-17s%-17s\n", ceph_ino(inode),
>  		   cap->session->s_mds,
>  		   ceph_cap_string(cap->issued),
>  		   ceph_cap_string(cap->implemented));
> +	spin_unlock(&ci->i_ceph_lock);
>  	return 0;
>  }
>=20=20
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 294af79c25c9..fb777add2257 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -1786,7 +1786,7 @@ static void cleanup_session_requests(struct ceph_md=
s_client *mdsc,
>   * Caller must hold session s_mutex.
>   */
>  int ceph_iterate_session_caps(struct ceph_mds_session *session,
> -			      int (*cb)(struct inode *, struct ceph_cap *,
> +			      int (*cb)(struct inode *, struct rb_node *ci_node,
>  					void *), void *arg)
>  {
>  	struct list_head *p;
> @@ -1799,6 +1799,8 @@ int ceph_iterate_session_caps(struct ceph_mds_sessi=
on *session,
>  	spin_lock(&session->s_cap_lock);
>  	p =3D session->s_caps.next;
>  	while (p !=3D &session->s_caps) {
> +		struct rb_node *ci_node;
> +
>  		cap =3D list_entry(p, struct ceph_cap, session_caps);
>  		inode =3D igrab(&cap->ci->netfs.inode);
>  		if (!inode) {
> @@ -1806,6 +1808,7 @@ int ceph_iterate_session_caps(struct ceph_mds_sessi=
on *session,
>  			continue;
>  		}
>  		session->s_cap_iterator =3D cap;
> +		ci_node =3D &cap->ci_node;
>  		spin_unlock(&session->s_cap_lock);
>=20=20
>  		if (last_inode) {
> @@ -1817,7 +1820,7 @@ int ceph_iterate_session_caps(struct ceph_mds_sessi=
on *session,
>  			old_cap =3D NULL;
>  		}
>=20=20
> -		ret =3D cb(inode, cap, arg);
> +		ret =3D cb(inode, ci_node, arg);
>  		last_inode =3D inode;
>=20=20
>  		spin_lock(&session->s_cap_lock);
> @@ -1850,20 +1853,26 @@ int ceph_iterate_session_caps(struct ceph_mds_ses=
sion *session,
>  	return ret;
>  }
>=20=20
> -static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *=
cap,
> +static int remove_session_caps_cb(struct inode *inode, struct rb_node *c=
i_node,
>  				  void *arg)
>  {
>  	struct ceph_inode_info *ci =3D ceph_inode(inode);
>  	bool invalidate =3D false;
> -	int iputs;
> +	struct ceph_cap *cap;
> +	int iputs =3D 0;
>=20=20
> -	dout("removing cap %p, ci is %p, inode is %p\n",
> -	     cap, ci, &ci->netfs.inode);
>  	spin_lock(&ci->i_ceph_lock);
> -	iputs =3D ceph_purge_inode_cap(inode, cap, &invalidate);
> +	cap =3D rb_entry(ci_node, struct ceph_cap, ci_node);
> +	if (cap) {
> +		dout(" removing cap %p, ci is %p, inode is %p\n",
> +		     cap, ci, &ci->netfs.inode);
> +
> +		iputs =3D ceph_purge_inode_cap(inode, cap, &invalidate);
> +	}
>  	spin_unlock(&ci->i_ceph_lock);
>=20=20
> -	wake_up_all(&ci->i_cap_wq);
> +	if (cap)
> +		wake_up_all(&ci->i_cap_wq);
>  	if (invalidate)
>  		ceph_queue_invalidate(inode);
>  	while (iputs--)
> @@ -1934,8 +1943,7 @@ enum {
>   *
>   * caller must hold s_mutex.
>   */
> -static int wake_up_session_cb(struct inode *inode, struct ceph_cap *cap,
> -			      void *arg)
> +static int wake_up_session_cb(struct inode *inode, struct rb_node *ci_no=
de, void *arg)
>  {
>  	struct ceph_inode_info *ci =3D ceph_inode(inode);
>  	unsigned long ev =3D (unsigned long)arg;
> @@ -1946,12 +1954,14 @@ static int wake_up_session_cb(struct inode *inode=
, struct ceph_cap *cap,
>  		ci->i_requested_max_size =3D 0;
>  		spin_unlock(&ci->i_ceph_lock);
>  	} else if (ev =3D=3D RENEWCAPS) {
> -		if (cap->cap_gen < atomic_read(&cap->session->s_cap_gen)) {
> -			/* mds did not re-issue stale cap */
> -			spin_lock(&ci->i_ceph_lock);
> +		struct ceph_cap *cap;
> +
> +		spin_lock(&ci->i_ceph_lock);
> +		cap =3D rb_entry(ci_node, struct ceph_cap, ci_node);
> +		/* mds did not re-issue stale cap */
> +		if (cap && cap->cap_gen < atomic_read(&cap->session->s_cap_gen))
>  			cap->issued =3D cap->implemented =3D CEPH_CAP_PIN;
> -			spin_unlock(&ci->i_ceph_lock);
> -		}
> +		spin_unlock(&ci->i_ceph_lock);
>  	} else if (ev =3D=3D FORCE_RO) {
>  	}
>  	wake_up_all(&ci->i_cap_wq);
> @@ -2113,16 +2123,22 @@ static bool drop_negative_children(struct dentry =
*dentry)
>   * Yes, this is a bit sloppy.  Our only real goal here is to respond to
>   * memory pressure from the MDS, though, so it needn't be perfect.
>   */
> -static int trim_caps_cb(struct inode *inode, struct ceph_cap *cap, void =
*arg)
> +static int trim_caps_cb(struct inode *inode, struct rb_node *ci_node, vo=
id *arg)
>  {
>  	int *remaining =3D arg;
>  	struct ceph_inode_info *ci =3D ceph_inode(inode);
>  	int used, wanted, oissued, mine;
> +	struct ceph_cap *cap;
>=20=20
>  	if (*remaining <=3D 0)
>  		return -1;
>=20=20
>  	spin_lock(&ci->i_ceph_lock);
> +	cap =3D rb_entry(ci_node, struct ceph_cap, ci_node);
> +	if (!cap) {
> +		spin_unlock(&ci->i_ceph_lock);
> +		return 0;
> +	}
>  	mine =3D cap->issued | cap->implemented;
>  	used =3D __ceph_caps_used(ci);
>  	wanted =3D __ceph_caps_file_wanted(ci);
> @@ -4265,26 +4281,23 @@ static struct dentry* d_find_primary(struct inode=
 *inode)
>  /*
>   * Encode information about a cap for a reconnect with the MDS.
>   */
> -static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
> +static int reconnect_caps_cb(struct inode *inode, struct rb_node *ci_nod=
e,
>  			  void *arg)
>  {
>  	union {
>  		struct ceph_mds_cap_reconnect v2;
>  		struct ceph_mds_cap_reconnect_v1 v1;
>  	} rec;
> -	struct ceph_inode_info *ci =3D cap->ci;
> +	struct ceph_inode_info *ci =3D ceph_inode(inode);
>  	struct ceph_reconnect_state *recon_state =3D arg;
>  	struct ceph_pagelist *pagelist =3D recon_state->pagelist;
>  	struct dentry *dentry;
> +	struct ceph_cap *cap;
>  	char *path;
> -	int pathlen =3D 0, err;
> +	int pathlen =3D 0, err =3D 0;
>  	u64 pathbase;
>  	u64 snap_follows;
>=20=20
> -	dout(" adding %p ino %llx.%llx cap %p %lld %s\n",
> -	     inode, ceph_vinop(inode), cap, cap->cap_id,
> -	     ceph_cap_string(cap->issued));
> -
>  	dentry =3D d_find_primary(inode);
>  	if (dentry) {
>  		/* set pathbase to parent dir when msg_version >=3D 2 */
> @@ -4301,6 +4314,15 @@ static int reconnect_caps_cb(struct inode *inode, =
struct ceph_cap *cap,
>  	}
>=20=20
>  	spin_lock(&ci->i_ceph_lock);
> +	cap =3D rb_entry(ci_node, struct ceph_cap, ci_node);
> +	if (!cap) {
> +		spin_unlock(&ci->i_ceph_lock);
> +		goto out_err;
> +	}
> +	dout(" adding %p ino %llx.%llx cap %p %lld %s\n",
> +	     inode, ceph_vinop(inode), cap, cap->cap_id,
> +	     ceph_cap_string(cap->issued));
> +
>  	cap->seq =3D 0;        /* reset cap seq */
>  	cap->issue_seq =3D 0;  /* and issue_seq */
>  	cap->mseq =3D 0;       /* and migrate_seq */
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 0f70ca3cdb21..001b69d04307 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -569,7 +569,7 @@ extern void ceph_queue_cap_reclaim_work(struct ceph_m=
ds_client *mdsc);
>  extern void ceph_reclaim_caps_nr(struct ceph_mds_client *mdsc, int nr);
>  extern int ceph_iterate_session_caps(struct ceph_mds_session *session,
>  				     int (*cb)(struct inode *,
> -					       struct ceph_cap *, void *),
> +					       struct rb_node *ci_node, void *),
>  				     void *arg);
>  extern void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc);
>=20=20
> --=20
>
> 2.39.2
>
