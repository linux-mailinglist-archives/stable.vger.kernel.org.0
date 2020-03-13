Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16D93183E02
	for <lists+stable@lfdr.de>; Fri, 13 Mar 2020 01:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgCMA5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 20:57:14 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:52482 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbgCMA5N (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Mar 2020 20:57:13 -0400
Received: by mail-pj1-f66.google.com with SMTP id f15so3273150pjq.2;
        Thu, 12 Mar 2020 17:57:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JYErxPxUaGUBplLH65PeMy/hBKN4L+ixr3Dg3MVBjtY=;
        b=qaHP9ogT8oLWmwccMZEGLlbI9D/F1DKloHtOY31zjA0L3EH1WcmXf9E1jpHkguu98U
         8q05vMJC0B3v3dzdE+3ThU1qLnI2QdgeWldMTZgrfQdGO1J0LiPSR/ZrDEzKSNk3w45K
         7MitT3y0tbKs11M6DlYJLs+Q8xsskBT09fXhErLJkRGv1EA4/pSkHU5AqOaXkoDQp4RY
         AkLYFeGIAkAO/jiapANF12OKc5sn3qXKBu067kVqjMcZ28rGEx0vCVyF7s2HCrO34E0K
         yZ4Q8KeqvN1ZcugDk8oxBgDiVhkZG83MOpBw80rKhGKUd4Gepo384WZApKuqEsYvfIQ9
         CbqQ==
X-Gm-Message-State: ANhLgQ33LKari1ageN6/hB2JrWuxXwTN7HweA/C13KvXFbe/TICfBfvz
        ZXG/conHTj8WDqNkg+ESWlc=
X-Google-Smtp-Source: ADFU+vtVU3sloKfNJ/GHy6v7uSunVn8TinhhgU2e25piz35fqisnm35446HRFefBgI5y9Gx35kOMPg==
X-Received: by 2002:a17:902:be08:: with SMTP id r8mr10871611pls.321.1584061032688;
        Thu, 12 Mar 2020 17:57:12 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id y7sm16017401pfq.159.2020.03.12.17.57.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 17:57:11 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id A6ED24028E; Fri, 13 Mar 2020 00:57:10 +0000 (UTC)
Date:   Fri, 13 Mar 2020 00:57:10 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeff Vander Stoep <jeffv@google.com>,
        Jessica Yu <jeyu@kernel.org>,
        Kees Cook <keescook@chromium.org>, NeilBrown <neilb@suse.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/4] kmod: make request_module() return an error when
 autoloading is disabled
Message-ID: <20200313005710.GQ11244@42.do-not-panic.com>
References: <20200312202552.241885-1-ebiggers@kernel.org>
 <20200312202552.241885-2-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312202552.241885-2-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 12, 2020 at 01:25:49PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> It's long been possible to disable kernel module autoloading completely
> (while still allowing manual module insertion) by setting
> /proc/sys/kernel/modprobe to the empty string.  This can be preferable
> to setting it to a nonexistent file since it avoids the overhead of an
> attempted execve(), avoids potential deadlocks, and avoids the call to
> security_kernel_module_request() and thus on SELinux-based systems
> eliminates the need to write SELinux rules to dontaudit module_request.
> 
> However, when module autoloading is disabled in this way,
> request_module() returns 0.  This is broken because callers expect 0 to
> mean that the module was successfully loaded.
> 
> Apparently this was never noticed because this method of disabling
> module autoloading isn't used much, and also most callers don't use the
> return value of request_module() since it's always necessary to check
> whether the module registered its functionality or not anyway.  But
> improperly returning 0 can indeed confuse a few callers, for example
> get_fs_type() in fs/filesystems.c where it causes a WARNING to be hit:
> 
> 	if (!fs && (request_module("fs-%.*s", len, name) == 0)) {
> 		fs = __get_fs_type(name, len);
> 		WARN_ONCE(!fs, "request_module fs-%.*s succeeded, but still no fs?\n", len, name);
> 	}
> 
> This is easily reproduced with:
> 
> 	echo > /proc/sys/kernel/modprobe
> 	mount -t NONEXISTENT none /
> 
> It causes:
> 
> 	request_module fs-NONEXISTENT succeeded, but still no fs?
> 	WARNING: CPU: 1 PID: 1106 at fs/filesystems.c:275 get_fs_type+0xd6/0xf0
> 	[...]
> 
> This should actually use pr_warn_once() rather than WARN_ONCE(), since
> it's also user-reachable if userspace immediately unloads the module.
> Regardless, request_module() should correctly return an error when it
> fails.  So let's make it return -ENOENT, which matches the error when
> the modprobe binary doesn't exist.
> 
> I've also sent patches to document and test this case.
> 
> Cc: stable@vger.kernel.org
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jeff Vander Stoep <jeffv@google.com>
> Cc: Jessica Yu <jeyu@kernel.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Luis Chamberlain <mcgrof@kernel.org>
> Cc: NeilBrown <neilb@suse.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis
