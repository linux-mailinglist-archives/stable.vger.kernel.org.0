Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 247103D339
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 19:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405254AbfFKRCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 13:02:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57921 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404282AbfFKRCY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Jun 2019 13:02:24 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7FC7AC0546D3;
        Tue, 11 Jun 2019 17:02:24 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-16.phx2.redhat.com [10.3.112.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DF51B60BF7;
        Tue, 11 Jun 2019 17:02:15 +0000 (UTC)
Date:   Tue, 11 Jun 2019 13:02:13 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     selinux@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        linux-audit@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH] selinux: log raw contexts as untrusted strings
Message-ID: <20190611170213.ecw2hhxxcy3d476n@madcap2.tricolour.ca>
References: <20190611080719.28625-1-omosnace@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190611080719.28625-1-omosnace@redhat.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 11 Jun 2019 17:02:24 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019-06-11 10:07, Ondrej Mosnacek wrote:
> These strings may come from untrusted sources (e.g. file xattrs) so they
> need to be properly escaped.
> 
> Reproducer:
>     # setenforce 0
>     # touch /tmp/test
>     # setfattr -n security.selinux -v 'kuřecí řízek' /tmp/test
>     # runcon system_u:system_r:sshd_t:s0 cat /tmp/test
>     (look at the generated AVCs)
> 
> Actual result:
>     type=AVC [...] trawcon=kuřecí řízek
> 
> Expected result:
>     type=AVC [...] trawcon=6B75C5996563C3AD20C599C3AD7A656B
> 
> Fixes: fede148324c3 ("selinux: log invalid contexts in AVCs")
> Cc: stable@vger.kernel.org # v5.1+
> Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>

Acked-by: Richard Guy Briggs <rgb@redhat.com>

> ---
>  security/selinux/avc.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/security/selinux/avc.c b/security/selinux/avc.c
> index 8346a4f7c5d7..a99be508f93d 100644
> --- a/security/selinux/avc.c
> +++ b/security/selinux/avc.c
> @@ -739,14 +739,20 @@ static void avc_audit_post_callback(struct audit_buffer *ab, void *a)
>  	rc = security_sid_to_context_inval(sad->state, sad->ssid, &scontext,
>  					   &scontext_len);
>  	if (!rc && scontext) {
> -		audit_log_format(ab, " srawcon=%s", scontext);
> +		if (scontext_len && scontext[scontext_len - 1] == '\0')
> +			scontext_len--;
> +		audit_log_format(ab, " srawcon=");
> +		audit_log_n_untrustedstring(ab, scontext, scontext_len);
>  		kfree(scontext);
>  	}
>  
>  	rc = security_sid_to_context_inval(sad->state, sad->tsid, &scontext,
>  					   &scontext_len);
>  	if (!rc && scontext) {
> -		audit_log_format(ab, " trawcon=%s", scontext);
> +		if (scontext_len && scontext[scontext_len - 1] == '\0')
> +			scontext_len--;
> +		audit_log_format(ab, " trawcon=");
> +		audit_log_n_untrustedstring(ab, scontext, scontext_len);
>  		kfree(scontext);
>  	}
>  }
> -- 
> 2.20.1
> 
> --
> Linux-audit mailing list
> Linux-audit@redhat.com
> https://www.redhat.com/mailman/listinfo/linux-audit

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
