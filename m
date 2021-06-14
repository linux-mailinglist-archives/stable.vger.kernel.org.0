Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 718CB3A723C
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 00:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbhFNWyG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 18:54:06 -0400
Received: from mail-pl1-f180.google.com ([209.85.214.180]:33449 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbhFNWyF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 18:54:05 -0400
Received: by mail-pl1-f180.google.com with SMTP id u18so6801473plc.0
        for <stable@vger.kernel.org>; Mon, 14 Jun 2021 15:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aciRkOzayHTWrTzSJKmVf13JrZoWxtea1Rx5Gqhhjmg=;
        b=nIwp+FZxbhehtXuzhGjb6YSm7hYtx2sK8E76UiJ5RWfCYIPYLLGpUB7odZ3pY6zsSv
         MgZhR/qK5xP1/GaERZvUSbyzt9nXy1Z26iJ6XYs/rswA09QvHCRH1Zm3w8c7Iiwk1CQV
         qLnd5kMTVtgJ7vCLk1aVpVW8+o/q0Sae0xiY0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aciRkOzayHTWrTzSJKmVf13JrZoWxtea1Rx5Gqhhjmg=;
        b=Zj50pqJyrzaw0mcmSX/tER4qefbG6Nm45TqUMy1/e7iCgYpEbUek8n99ir9sh9vGNL
         LuiQtb9Pf/7ONz0xtvGBgRGv/diLTqYQYYwS9+fG0Pv4qDalPw9KtfA1Fa8z48J/nX0l
         57/tFKOW+Aa7nnsp3oSQpGuwNf2+bei37tp5w0OVPhXTto1VdoqTOP0bbaHG+Sh54Z1f
         Wgl869Kn2H82K/mySohruxnibf+Pu1Vz3nFvxUYfXOBdDH9lAOPMcueljhG6T3iobilY
         CE/oKWkOSpk0C5hc9b/6FHkwui0PaJ1QCFUauLmhu5yPOH4Svz0pzb94HmnljTqB1k8D
         vpSA==
X-Gm-Message-State: AOAM533e0SZ6cQR8FLRClnSKm9GRNk3R0voi+8HwILLABwtAHqGTStC4
        O9rsZjW46M5xSYVocRecZYpRWw==
X-Google-Smtp-Source: ABdhPJwpQvuLgIPeiP/70rxgicnMCOhXHbg3vIOZOxpkA7GVBdOBxrKghch1YeGH+GEgoNG2dpP50Q==
X-Received: by 2002:a17:902:c651:b029:118:896f:cead with SMTP id s17-20020a170902c651b0290118896fceadmr1287574pls.29.1623711052271;
        Mon, 14 Jun 2021 15:50:52 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d8sm13816594pfq.198.2021.06.14.15.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 15:50:51 -0700 (PDT)
Date:   Mon, 14 Jun 2021 15:50:50 -0700
From:   Kees Cook <keescook@chromium.org>
To:     youling 257 <youling257@gmail.com>
Cc:     torvalds@linux-foundation.org, christian.brauner@ubuntu.com,
        andrea.righi@canonical.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, regressions@lists.linux.dev,
        linux-security-module@vger.kernel.org,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        SElinux list <selinux@vger.kernel.org>
Subject: Re: [PATCH] proc: Track /proc/$pid/attr/ opener mm_struct
Message-ID: <202106141503.B3144DFE@keescook>
References: <20210608171221.276899-1-keescook@chromium.org>
 <20210614100234.12077-1-youling257@gmail.com>
 <202106140826.7912F27CD@keescook>
 <202106140941.7CE5AE64@keescook>
 <CAOzgRdZJeN6sQWP=Ou0H3bTrp+7ijKuJikG-f4eer5f1oVjrCQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOzgRdZJeN6sQWP=Ou0H3bTrp+7ijKuJikG-f4eer5f1oVjrCQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 15, 2021 at 02:46:19AM +0800, youling 257 wrote:
> I test this patch cause "init: cannot setexeccon(u:r:ueventd:s0)
> operation not permitted.
> init ctrl_write_limited.

Thanks for testing!

This appears to come from here:
https://github.com/aosp-mirror/platform_system_core/blob/master/init/service.cpp#L242


In setexeccon(), I see (pid=0, attr="exec"):

        fd = openattr(pid, attr, O_RDWR | O_CLOEXEC);
...
                        ret = write(fd, context2, strlen(context2) + 1);
...
        close(fd);


and openattr() is doing:
...
                rc = asprintf(&path, "/proc/thread-self/attr/%s", attr);
                if (rc < 0)
                        return -1;
                fd = open(path, flags | O_CLOEXEC);
...

I'm not sure how the above could fail. (mm_access() always allows
introspection...)

The only way I can understand the check failing is if a process did:

open, exec, write

But setexeccon() is not doing anything between the open and the write...

I will keep looking...

-Kees

-- 
Kees Cook
