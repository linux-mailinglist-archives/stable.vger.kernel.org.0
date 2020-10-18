Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87A7B291634
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 07:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725306AbgJRFzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 01:55:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725275AbgJRFzW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 01:55:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DED22080D;
        Sun, 18 Oct 2020 05:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603000521;
        bh=/4n7yLggyoNtH3XjTHMAsEyUJHjKrP5RLPAORwdFV9w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RYwGXiw3FuhLZkYf78rQYxDgCIZEREEfAKazJ3JMQsC7+msJi/qa/EhHNScbvAEmT
         qR9bR1wN6j0GrNEmyf+iiEDj4IHxug9B1AftsoSabNodXCChC94gjeLoJUykwuicFV
         br9fJWuVombiYdmssI2DlrRlrj6WV/UAtDmVB3Pw=
Date:   Sun, 18 Oct 2020 07:55:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Boris Protopopov <pboris@amazon.com>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: [PATCH 4.9-5.8] Convert trailing spaces and periods in path
 components
Message-ID: <20201018055519.GB599591@kroah.com>
References: <20201017152839.4398-1-pboris@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201017152839.4398-1-pboris@amazon.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 17, 2020 at 03:28:39PM +0000, Boris Protopopov wrote:
> When converting trailing spaces and periods in paths, do so
> for every component of the path, not just the last component.
> If the conversion is not done for every path component, then
> subsequent operations in directories with trailing spaces or
> periods (e.g. create(), mkdir()) will fail with ENOENT. This
> is because on the server, the directory will have a special
> symbol in its name, and the client needs to provide the same.
> 
> Cc: <stable@vger.kernel.org> # 4.9.x-5.8.x
> Signed-off-by: Boris Protopopov <pboris@amazon.com>
> ---
>  fs/cifs/cifs_unicode.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
> index 498777d859eb..9bd03a231032 100644
> --- a/fs/cifs/cifs_unicode.c
> +++ b/fs/cifs/cifs_unicode.c
> @@ -488,7 +488,13 @@ cifsConvertToUTF16(__le16 *target, const char *source, int srclen,
>  		else if (map_chars == SFM_MAP_UNI_RSVD) {
>  			bool end_of_string;
>  
> -			if (i == srclen - 1)
> +			/**
> +			 * Remap spaces and periods found at the end of every
> +			 * component of the path. The special cases of '.' and
> +			 * '..' do not need to be dealt with explicitly because
> +			 * they are addressed in namei.c:link_path_walk().
> +			 **/
> +			if ((i == srclen - 1) || (source[i+1] == '\\'))
>  				end_of_string = true;
>  			else
>  				end_of_string = false;
> -- 
> 2.18.4
> 

What is the git commit id of this in Linus's tree?

thanks,

greg k-h
