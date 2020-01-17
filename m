Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 519D11412AA
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 22:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgAQVPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jan 2020 16:15:07 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:37239 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbgAQVPH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jan 2020 16:15:07 -0500
Received: by mail-pj1-f65.google.com with SMTP id m13so3884074pjb.2
        for <stable@vger.kernel.org>; Fri, 17 Jan 2020 13:15:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hDjGeeleL+HbTBakSqxyCbAUHlP2+qcu6KumLAPqXUU=;
        b=BSQILfuBRSQobvuJiAwCAtFsCtM5EZ3Yjz+WXkxV3tDNF5BEcRY5ml8/FNx+XC8r/U
         6vyAvm4ctOfcS7xDBhoVpynWvqR8/3HjleemRToNRjKjCR6ms8QKn+6An++QgXP1j8uX
         in1mTw1za0l9RIg4JeYi2tH7UWttIWEWUb1og=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hDjGeeleL+HbTBakSqxyCbAUHlP2+qcu6KumLAPqXUU=;
        b=p1ZjRdx0prKGo01f3k7EL5am/GqEUb+b+VZy+Vu1/fNyXuvN+D1SPT5yf6tTjj5B+P
         dvqoMb5zLU6MnO4ddfCJn7MXvGkFBDj796JCwdR3CeoQn2WaDv7zMQeveDE2Fzewiozz
         oRypfMnoBnWttUEWMhvyQHkiwt1RczVBWeVQhesEJU/8yofyZ2WdvlCGTQnm6DdGBAAM
         hptAnt8V5xOL6OpmFpM713dEQm6ZcPeoGfJZRn4F6it1XMfFgiSxGcTAifbv8djAA13M
         0r21Wk90xGxfIGAqFCzy+l9cc1nKVf+FlS+x+2vVYmgaiILJYeDcXQqdnwHJR/P43DrB
         lgaQ==
X-Gm-Message-State: APjAAAUp7L8i22FootWFqqBAwr7gltGIvmGFOx9Xeey6scn9O4SwDpBX
        41TtuH2Ad0tntAIND7/hjYmz1w==
X-Google-Smtp-Source: APXvYqxj2qC2Kag4Dy81hHsTvTzPaCLiACq64wPFUzQ1WtYhCxyGXVujZhSdp9ocQqLQzPqwwuoxLg==
X-Received: by 2002:a17:90a:c705:: with SMTP id o5mr8049276pjt.67.1579295706568;
        Fri, 17 Jan 2020 13:15:06 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id a23sm32043042pfg.82.2020.01.17.13.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 13:15:05 -0800 (PST)
Date:   Fri, 17 Jan 2020 13:15:04 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     linux-kernel@vger.kernel.org, Jann Horn <jannh@google.com>,
        Oleg Nesterov <oleg@redhat.com>, stable@vger.kernel.org,
        Serge Hallyn <serge@hallyn.com>, Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH v3] ptrace: reintroduce usage of subjective credentials
 in ptrace_has_cap()
Message-ID: <202001171310.A74535C0@keescook>
References: <20200117105717.29803-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200117105717.29803-1-christian.brauner@ubuntu.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 17, 2020 at 11:57:18AM +0100, Christian Brauner wrote:
> -static int ptrace_has_cap(struct user_namespace *ns, unsigned int mode)
> +static int ptrace_has_cap(const struct cred *cred, struct user_namespace *ns,
> +			  unsigned int mode)
>  {
> -	if (mode & PTRACE_MODE_NOAUDIT)
> -		return has_ns_capability_noaudit(current, ns, CAP_SYS_PTRACE);
> -	else
> -		return has_ns_capability(current, ns, CAP_SYS_PTRACE);
> +	return security_capable(cred, ns, CAP_SYS_PTRACE,
> +				(mode & PTRACE_MODE_NOAUDIT) ? CAP_OPT_NOAUDIT :
> +							       CAP_OPT_NONE);
>  }

Eek, no. I think this inverts the check.

Before:
bool has_ns_capability(struct task_struct *t,
                       struct user_namespace *ns, int cap)
{
	...
        ret = security_capable(__task_cred(t), ns, cap, CAP_OPT_NONE);
	...
        return (ret == 0);
}

static int ptrace_has_cap(struct user_namespace *ns, unsigned int mode)
{
	...
                return has_ns_capability(current, ns, CAP_SYS_PTRACE);
}

After:
static int ptrace_has_cap(const struct cred *cred, struct user_namespace *ns,
                       unsigned int mode)
{
	return security_capable(cred, ns, CAP_SYS_PTRACE,
				(mode & PTRACE_MODE_NOAUDIT) ? CAP_OPT_NOAUDIT :
							       CAP_OPT_NONE);
}

Note lack of "== 0" on the security_capable() return value, but it's
needed. To avoid confusion, I think ptrace_has_cap() should likely
return bool too.

-Kees

-- 
Kees Cook
